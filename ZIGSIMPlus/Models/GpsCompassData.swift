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

public class GpsCompassData :NSObject,CLLocationManagerDelegate {
    // Singleton instance
    static let shared = GpsCompassData()

    // MARK: - Instance Properties
    var locationManager: CLLocationManager?

    private override init() {
        super.init()
        if #available(iOS 8.0, *) {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager()
                self.locationManager?.requestWhenInUseAuthorization()
                self.locationManager?.delegate = self;
            }
        }

    }

    // MARK: - Public methods
}
