//
//  LocationDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreLocation

/// Data store for commands which depend on LocationManager.
/// e.g.) GPS, iBeacon, etc.
public class LocationDataStore: NSObject {

    /// Singleton instance
    static let shared = LocationDataStore()

    // MARK: - Instance Properties

    private var isEnabled: Bool = false
    private var isAuthorized: Bool = false
    private let locationManager: CLLocationManager = CLLocationManager()

    // For GPS
    private var latitudeData: Double = 0.0
    private var longitudeData: Double = 0.0
    var callbackGps: (([Double]) -> Void)? = nil

    // For compass
    private var compassData: Double = 0.0
    var callbackCompass: ((Double) -> Void)? = nil

    // beacons data
    private let beaconRegion : CLBeaconRegion
    private var beacons: [CLBeacon] = [CLBeacon]()
    var beaconsCallback: (([CLBeacon]) -> Void)? = nil

    private override init() {
        // Init GPS
        locationManager.distanceFilter = 1.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Init compass
        /* T.B.D 設定画面で向きを設定変更できるようにする↓ */
        locationManager.headingOrientation = .faceUp
        locationManager.headingOrientation = .portrait

        // Init beacons
        let appSetting = AppSettingModel.shared
        let uuid = UUID(uuidString: appSetting.beaconUUID)!
        let deviceUUID =  appSetting.deviceUUID
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "\(deviceUUID) region")
    }

    // MARK: - Public methods

    func enable() {
        isEnabled = true

        if #available(iOS 8.0, *) {
            locationManager.delegate = self
            if isAuthorized {
                locationManager.startMonitoring(for: beaconRegion)
                locationManager.startRangingBeacons(in: beaconRegion)
            }
            else {
                // Request authorization if needed
                locationManager.requestAlwaysAuthorization()
            }
        } else {
            // Fallback on earlier versions
        }
    }

    func disable() {
        isEnabled = false
        if isAuthorized {
            locationManager.stopRangingBeacons(in: beaconRegion)
            locationManager.stopMonitoring(for: beaconRegion)
        }
        beacons.removeAll() // Reset data
    }

    func startGps() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingLocation()
            }
        }
    }

    func stopGps() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.stopUpdatingLocation()
            }
        }
    }

    func startCompass() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.startUpdatingHeading()
            }
        }
    }

    func stopCompass() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                locationManager.stopUpdatingHeading()
            }
        }
    }

    // MARK: - Private methods

    private func updateCompassData() {
        print("compassData:\(self.compassData)")
        callbackCompass?(self.compassData)
    }

    private func updateGpsData() {
        print("gpsData:latitudeData:\(self.latitudeData)")
        print("gpsData:longitudeData:\(self.longitudeData)")
        var gpsData = [0.0,0.0]
        gpsData[0] = self.latitudeData
        gpsData[1] = self.longitudeData
        callbackGps?(gpsData)
    }

    private func updateBeaconsData() {
        print("beacons:\(beacons.count)")
        beaconsCallback?(beacons)
    }
}

// MARK: - CLLocationManagerDelegate methods

extension LocationDataStore: CLLocationManagerDelegate {
    public final func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitudeData = (locations.last?.coordinate.latitude)!
        self.longitudeData = (locations.last?.coordinate.longitude)!
        updateGpsData()
    }

    public func locationManager(_ manager:CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.compassData = newHeading.magneticHeading
        updateCompassData()
    }

    // Called when the device started monitoring
    public func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Start monitoring for iBeacon")
    }

    // Called when new data is received from beacons
    public func locationManager(_ manager: CLLocationManager, didRangeBeacons newBeacons: [CLBeacon], in region: CLBeaconRegion) {
        for b in newBeacons {
            // Check if the beacon is already registered
            let index = beacons.firstIndex(where: {
                $0.proximityUUID == b.proximityUUID && $0.major == b.major && $0.minor == b.minor
            })

            if index == nil {
                // Add beacon data
                print("Found iBeacon: uuid:\(b.proximityUUID.uuidString) major:\(b.major.intValue) minor:\(b.minor.intValue) rssi:\(b.rssi)")
                beacons.append(b)
            }
            else {
                // Update beacon data
                beacons[index!] = b
                print("Updated iBeacon: uuid:\(b.proximityUUID.uuidString) major:\(b.major.intValue) minor:\(b.minor.intValue) rssi:\(b.rssi)")
            }
        }
        updateBeaconsData()
    }

    // Called when the user authorized monitorin location data
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
            break;
        default:
            break;
        }
    }
}
