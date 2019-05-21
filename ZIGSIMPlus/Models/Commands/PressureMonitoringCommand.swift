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
    
    private var altimeter:AnyObject!
    private var isWorking = false
    
    public func start(completion: ((String?) -> Void)?) {
        if #available(iOS 8.0, *) {
            altimeter = CMAltimeter()
            isWorking = true
        } else {
            altimeter = false as AnyObject
        }

        if #available(iOS 8.0, *) {
            if CMAltimeter.isRelativeAltitudeAvailable() {
                altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main, withHandler: { (data, error) in
                    if error == nil {
                        print("ok")
                        completion?("""
                            pressure:pressure: \(Double(truncating: data!.pressure) * 10.0))
                            pressure:altitude: \(Double(truncating: data!.relativeAltitude))
                            """)
                    }
                })
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        if isWorking {
            altimeter.stopRelativeAltitudeUpdates()
        }
        completion?(nil)
    }
}
