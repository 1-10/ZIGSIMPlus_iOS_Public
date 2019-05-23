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
    
    public func start(completion: ((String?) -> Void)?) {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceMotion, error) in
                guard error == nil,
                    let motion = deviceMotion else {
                        completion?("motion unavailable")
                        return
                }
                
                guard let isAccelerationActive = AppSettingModel.shared.isActiveByCommandData[LabelConstants.acceleration],
                    let isGravityActive = AppSettingModel.shared.isActiveByCommandData[LabelConstants.gravity],
                    let isGyroActive = AppSettingModel.shared.isActiveByCommandData[LabelConstants.gyro],
                    let isQuaternionActive = AppSettingModel.shared.isActiveByCommandData[LabelConstants.quaternion]
                    else {
                        fatalError("AppSetting of the CommandData nil")
                }
                
                let result = self.getMotionResult(from: motion, isAccelerationActive: isAccelerationActive, isGravityActive: isGravityActive, isGyroActive: isGyroActive, isQuaternionActive: isQuaternionActive)
                completion?(result)
            }
        } else {
            completion?("motion unavailable")
        }
    }
    
    private func getMotionResult(from motion: CMDeviceMotion, isAccelerationActive: Bool, isGravityActive: Bool, isGyroActive: Bool, isQuaternionActive: Bool) -> String {

        var result = ""
        if isAccelerationActive {
            result += """
            accel:x:\(motion.userAcceleration.x)
            accel:y:\(motion.userAcceleration.y)
            accel:z:\(motion.userAcceleration.z)
            """
        }
        if isGravityActive {
            result += """
            gravity:x:\(motion.gravity.x)
            gravity:y:\(motion.gravity.y)
            gravity:z:\(motion.gravity.z)
            """
        }
        if isGyroActive {
            result += """
            gyro:x:\(motion.rotationRate.x)
            gyro:y:\(motion.rotationRate.y)
            gyro:z:\(motion.rotationRate.z)
            """
        }
        if isQuaternionActive {
            result += """
            quaternion:x:\(motion.attitude.quaternion.x)
            quaternion:y:\(motion.attitude.quaternion.y)
            quaternion:z:\(motion.attitude.quaternion.z)
            """
        }
        
        return result
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        if motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
        completion?(nil)
    }
}
