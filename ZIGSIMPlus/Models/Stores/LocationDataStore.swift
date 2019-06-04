//
//  LocationDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftOSC
import SwiftyJSON

/// Data store for commands which depend on LocationManager.
/// e.g.) GPS, iBeacon, etc.
public class LocationDataStore: NSObject {

    /// Singleton instance
    static let shared = LocationDataStore()

    // MARK: - Instance Properties

    private let locationManager: CLLocationManager = CLLocationManager()

    // For GPS
    private var latitudeData: Double = 0.0
    private var longitudeData: Double = 0.0
    var gpsCallback: (([Double]) -> Void)? = nil

    // For compass
    private var compassData: Double = 0.0
    var compassCallback: ((Double) -> Void)? = nil

    // beacons data
    private let beaconRegion : CLBeaconRegion
    private var beacons: [CLBeacon] = [CLBeacon]()
    var beaconsCallback: (([CLBeacon]) -> Void)? = nil

    private override init() {
        // Init GPS
        locationManager.distanceFilter = 1.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Init compass
        locationManager.headingFilter = kCLHeadingFilterNone
        
        // Init beacons
        let appSetting = AppSettingModel.shared
        let uuid = UUID(uuidString: appSetting.beaconUUID)!
        let deviceUUID =  appSetting.deviceUUID
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "\(deviceUUID) region")

        super.init()
        locationManager.delegate = self
    }

    // MARK: - Public methods

    func startBeacons() {
        if isLocationAvailable() {
            locationManager.requestAlwaysAuthorization()
            locationManager.startMonitoring(for: beaconRegion)
            locationManager.startRangingBeacons(in: beaconRegion)
        }
    }

    func stopBeacons() {
        if isLocationAvailable() {
            locationManager.stopRangingBeacons(in: beaconRegion)
            locationManager.stopMonitoring(for: beaconRegion)
        }
        beacons.removeAll() // Reset data
    }

    func startGps() {
        if isLocationAvailable() {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    func stopGps() {
        if isLocationAvailable() {
            locationManager.stopUpdatingLocation()
        }
    }

    func startCompass() {
        if isLocationAvailable() {
            locationManager.requestAlwaysAuthorization()
            if (AppSettingModel.shared.compassAngle == 0.0) {
                locationManager.headingOrientation = .portrait
            }  else if (AppSettingModel.shared.compassAngle == 1.0) {
                locationManager.headingOrientation = .faceUp
            }
            locationManager.startUpdatingHeading()
        }
    }

    func stopCompass() {
        if isLocationAvailable() {
            locationManager.stopUpdatingHeading()
        }
    }
    
    func isLocationAvailable() -> Bool {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                return true
            }
        }
        return false
    }

    // MARK: - Private methods

    private func updateCompassData() {
        print("compassData:\(self.compassData)")
        compassCallback?(self.compassData)
    }

    private func updateGpsData() {
        print("gpsData:latitudeData:\(self.latitudeData)")
        print("gpsData:longitudeData:\(self.longitudeData)")
        gpsCallback?([latitudeData, longitudeData])
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
        if status != .authorizedAlways || status != .authorizedWhenInUse {
            // TODO: Show error message
        }
    }
}

extension LocationDataStore : Store {
    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var data = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommandData[Label.gps]! {
            data.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/gps"), latitudeData, longitudeData))
        }
        
        if AppSettingModel.shared.isActiveByCommandData[Label.compass]! {
            data.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/compass"), compassData))
        }
        
        if AppSettingModel.shared.isActiveByCommandData[Label.beacon]! {
            data += beacons.enumerated().map { (i, beacon)  in
                return OSCMessage(
                    OSCAddressPattern("/\(deviceUUID)/beacon\(i)"),
                    beacon.proximityUUID.uuidString,
                    beacon.major.intValue,
                    beacon.minor.intValue,
                    beacon.rssi
                )
            }
        }

        return data
    }
    
    func toJSON() -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommandData[Label.gps]! {
            data["gps"] = JSON([latitudeData, longitudeData])
        }
        
        if AppSettingModel.shared.isActiveByCommandData[Label.compass]! {
            data["compass"] = JSON(compassData)
        }
        
        if AppSettingModel.shared.isActiveByCommandData[Label.beacon]! {
            let objs = beacons.map { beacon in
                return [
                    "uuid": beacon.proximityUUID.uuidString,
                    "major": beacon.major.intValue,
                    "minor": beacon.minor.intValue,
                    "rssi": beacon.rssi
                ]
            }
            data["beacons"] = JSON(objs)
        }

        return data
    }
}
