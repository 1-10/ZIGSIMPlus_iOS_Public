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
                MiscDataStore.shared.accel = motion.userAcceleration
                MiscDataStore.shared.gravity = motion.gravity
                MiscDataStore.shared.gyro = motion.rotationRate
                MiscDataStore.shared.quaternion = motion.attitude.quaternion
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
