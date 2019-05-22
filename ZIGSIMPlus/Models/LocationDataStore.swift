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
    private let beaconRegion : CLBeaconRegion
    private var beacons: [CLBeacon] = [CLBeacon]()
    var beaconsCallback: (([CLBeacon]) -> Void)? = nil
    
    private override init() {
        // Init beacons
        let appSetting = AppSettingModel.shared
        let uuid = UUID(uuidString: appSetting.beaconUUID)!
        let deviceUUID = "12345678" // TODO: replace with AppSettingModel.shared.deviceUUID
        beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "\(deviceUUID) region")
        beaconsCallback = nil
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

    // MARK: - Private methods
    
    private func updateBeacons() {
        print("beacons:\(beacons.count)")
        beaconsCallback?(beacons)
    }
}

// MARK: - CLLocationManagerDelegate methods

extension LocationDataStore: CLLocationManagerDelegate {
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
        updateBeacons()
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
