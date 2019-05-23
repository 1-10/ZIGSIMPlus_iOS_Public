//
//  GpsMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreLocation

public final class GpsMonitoringCommand: AutoUpdatedCommand {

    public func start(completion: ((String?) -> Void)?) {
        LocationDataStore.shared.startGps()
        LocationDataStore.shared.gpsCallback = { (gpsData) in
            completion?("""
                compass:latitude:\(gpsData[0])
                compass:longitude:\(gpsData[1])
                """)
        }
    }

    public func stop(completion: ((String?) -> Void)?) {
        LocationDataStore.shared.stopGps()
        completion?(nil)
    }
}
