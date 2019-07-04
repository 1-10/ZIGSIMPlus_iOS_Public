//
//  LocationService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftOSC
import SwiftyJSON

private func createBeaconRegion(_ appSetting: AppSettingModel) -> CLBeaconRegion {
    // TODO: Refactor AppSettingModel to return default values if invalid stored values are invalid
    let uuid = UUID(uuidString: appSetting.beaconUUID) ?? UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B570000")!
    let deviceUUID = appSetting.deviceUUID
    return CLBeaconRegion(proximityUUID: uuid, identifier: "\(deviceUUID) region")
}


/// Data store for commands which depend on LocationManager.
/// e.g.) GPS, iBeacon, etc.
public class LocationService: NSObject {

    /// Singleton instance
    static let shared = LocationService()

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
    private var beaconRegion : CLBeaconRegion
    private var beacons: [CLBeacon] = [CLBeacon]()
    var beaconsCallback: (([CLBeacon]) -> Void)? = nil

    private override init() {
        // Init GPS
        locationManager.distanceFilter = 1.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // Init compass
        locationManager.headingFilter = kCLHeadingFilterNone

        // Init beacons
        beaconRegion = createBeaconRegion(AppSettingModel.shared)

        super.init()
        locationManager.delegate = self
    }

    // MARK: - Public methods

    func startBeacons() {
        if isLocationAvailable() {
            beaconRegion = createBeaconRegion(AppSettingModel.shared)
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

            switch AppSettingModel.shared.compassOrientation {
            case .portrait:
                locationManager.headingOrientation = .portrait
            case .faceup:
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
}

// MARK: - CLLocationManagerDelegate methods

extension LocationService: CLLocationManagerDelegate {
    public final func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitudeData = (locations.last?.coordinate.latitude)!
        self.longitudeData = (locations.last?.coordinate.longitude)!
    }

    public func locationManager(_ manager:CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.compassData = newHeading.magneticHeading
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
    }

    // Called when the user authorized monitorin location data
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedAlways || status != .authorizedWhenInUse {
            // TODO: Show error message
        }
    }
}

extension LocationService : Service {
    func toLog() -> [String] {
        var log = [String]()

        var stringMsg = ""

        for (i, b) in beacons.enumerated() {
            stringMsg += "Beacon \(i): uuid:\(b.proximityUUID.uuidString) major:\(b.major.intValue) minor:\(b.minor.intValue) rssi:\(b.rssi)\n"
        }


        if AppSettingModel.shared.isActiveByCommand[Command.gps]! {
            log += [
                "gps:latitude:\(latitudeData)",
                "gps:longitude:\(longitudeData)"
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.compass]! {
            log += [
                "compass:compass:\(compassData)",
                "compass:faceup:\(AppSettingModel.shared.compassOrientation.rawValue)"
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.beacon]! {
            log += beacons.enumerated().map { (i, b) in
                return "Beacon \(i): uuid:\(b.proximityUUID.uuidString) major:\(b.major.intValue) minor:\(b.minor.intValue) rssi:\(b.rssi)\n"
            }
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var data = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.gps]! {
            data.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/gps"), latitudeData, longitudeData))
        }

        if AppSettingModel.shared.isActiveByCommand[Command.compass]! {
            data.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/compass"), compassData, AppSettingModel.shared.compassOrientation.rawValue))
        }

        if AppSettingModel.shared.isActiveByCommand[Command.beacon]! {
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

        if AppSettingModel.shared.isActiveByCommand[Command.gps]! {
            data["gps"] = JSON(["latitude": latitudeData, "longitude":longitudeData])
        }

        if AppSettingModel.shared.isActiveByCommand[Command.compass]! {
            data["compass"] = JSON(["compass": compassData,"faceup": AppSettingModel.shared.compassOrientation.rawValue])
        }

        if AppSettingModel.shared.isActiveByCommand[Command.beacon]! {
            let objs = beacons.map { beacon in
                return [
                    "uuid": beacon.proximityUUID.uuidString,
                    "major": beacon.major.intValue,
                    "minor": beacon.minor.intValue,
                    "rssi": beacon.rssi
                ]
            }
            data["beacon"] = JSON(objs)
        }

        return data
    }
}
