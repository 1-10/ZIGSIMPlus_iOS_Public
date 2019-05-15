//
//  AccelerationMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion

public final class AccelerationMonitoringCommand: Command {
    let motionManager = CMMotionManager()
    
    public func start(completion: ((String?) -> Void)?) {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.2
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerationData, error) in
                guard error == nil else {
                    completion?(error!.localizedDescription)
                    return
                }
                
                guard let accelData = accelerationData else {
                    completion?("No Acceleration Data")
                    return
                }
                
                completion?("x: \(accelData.acceleration.x) y: \(accelData.acceleration.y) z: \(accelData.acceleration.z)")
            }
        } else {
            completion?("Accelerometer Unavailable")
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
        completion?(nil)
    }
}
