//
//  PressureMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/20.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion

public final class PressureMonitoringCommand: AutoUpdatedCommand {
    let motionManager = CMMotionManager()
    private var altimeter = CMAltimeter()
    
    public func start(completion: ((String?) -> Void)?) {
//        var altimeter:AnyObject // Pressure
//        if #available(iOS 8.0, *) {
//            altimeter = CMAltimeter()
//        } else {
//            // Fallback on earlier versions
//            altimeter = false as AnyObject
//        }
        // atlimeter
        if #available(iOS 8.0, *) {
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                    print("update")
                    if error == nil {
                        completion?("""
                            pressure:pressure: \(Double(truncating: data!.pressure) * 10.0))
                            pressure:altitude: \(Double(truncating: data!.relativeAltitude))
                            """)
                    }
                })
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        completion?(nil)
    }
}
