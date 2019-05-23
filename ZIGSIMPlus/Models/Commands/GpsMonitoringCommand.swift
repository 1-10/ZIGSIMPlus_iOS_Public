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
        GpsCompassData.shared.startGps()
        GpsCompassData.shared.callbackGps = { (gpsData) in
            Messenger.send(gps: gpsData)
            completion?("""
                compass:latitude:\(gpsData[0])
                compass:longitude:\(gpsData[1])
                """)
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        GpsCompassData.shared.stopGps()
        completion?(nil)
    }
}
