//
//  MotionMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion

public final class MotionMonitoringCommand: AutoUpdatedCommand {
    let motionManager = CMMotionManager()
    
    public func isAvailable() -> Bool {
        return motionManager.isDeviceMotionAvailable
    }
    
    public func start(completion: ((String?) -> Void)?) {
        // TODO: These code might be moved to Store
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceMotion, error) in
                guard error == nil,
                    let motion = deviceMotion else {
                        completion?("motion unavailable")
                        return
                }
                
                // Save data to Store
                MotionDataStore.shared.accel = motion.userAcceleration
                MotionDataStore.shared.gravity = motion.gravity
                MotionDataStore.shared.gyro = motion.rotationRate
                MotionDataStore.shared.quaternion = motion.attitude.quaternion
            }
        } else {
            completion?("motion unavailable")
        }
    }

    public func stop(completion: ((String?) -> Void)?) {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
        completion?(nil)
    }
}
