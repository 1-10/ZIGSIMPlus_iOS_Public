//
//  LocationData.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftOSC

public class GpsCompassData :NSObject,CLLocationManagerDelegate {
    // Singleton instance
    static let shared = GpsCompassData()
    
    // MARK: - Instance Properties
    var callbackGps: (([Double]) -> Void)?
    var callbackCompass: ((Double) -> Void)?
    var latitudeData: Double
    var longitudeData: Double
    var compassData: Double
    var locationManager: CLLocationManager?
    
    private override init() {
        callbackGps = nil
        callbackCompass = nil
        latitudeData = 0.0
        longitudeData = 0.0
        compassData = 0.0
        super.init()
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager()
                self.locationManager?.requestWhenInUseAuthorization()
                self.locationManager?.delegate = self;
                self.locationManager?.distanceFilter = 1.0
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                /* T.B.D 設定画面で向きを設定変更できるようにする↓ */
                self.locationManager?.headingOrientation = .faceUp
                //self.locationManager?.headingOrientation = .portrait
            }
        }
        
    }
    
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
    
    public func locationManager(_ manager:CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.compassData = newHeading.magneticHeading
        updateCompassData()
    }
    
    public final func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latitudeData = (locations.last?.coordinate.latitude)!
        self.longitudeData = (locations.last?.coordinate.longitude)!
        updateGpsData()
    }
    
    // MARK: - Public methods
    func startGps() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.startUpdatingLocation()
            }
        }
    }
    
    func stopGps() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.stopUpdatingLocation()
            }
        }
    }
    
    func startCompass() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.startUpdatingHeading()
            }
        }
    }
    
    func stopCompass() {
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.stopUpdatingHeading()
            }
        }
    }
}

extension GpsCompassData : Store {
    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        
        return [
            OSCMessage(OSCAddressPattern("/\(deviceUUID)/gps"), latitudeData, longitudeData),
            OSCMessage(OSCAddressPattern("/\(deviceUUID)/compass"), compassData),
        ]
    }
    
    func toJSON() -> [String:AnyObject] {
        return [
            "gps": [latitudeData, longitudeData] as AnyObject,
            "compass": [compassData] as AnyObject
        ]
    }
}
