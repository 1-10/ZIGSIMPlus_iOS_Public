//
//  MotionMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion
import SwiftOSC

public final class MotionMonitoringCommand: AutoUpdatedCommand {
    let motionManager = CMMotionManager()
    
    public func start(completion: ((String?) -> Void)?) {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = AppSettingModel.shared.messageInterval
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerationData, error) in
                guard error == nil else {
                    completion?(error!.localizedDescription)
                    return
                }
                
                guard let accelData = accelerationData else {
                    completion?("no accel data")
                    return
                }
                
                let msg = OSCMessage(
                    OSCAddressPattern("/accel"),
                    accelData.acceleration.x,
                    accelData.acceleration.y,
                    accelData.acceleration.z
                )
                NetworkAdapter.shared.sendMessage(data: msg.data)
                
                completion?("""
                    accel:x:\(accelData.acceleration.x)
                    accel:y:\(accelData.acceleration.y)
                    accel:z:\(accelData.acceleration.z)
                    """)
            }
        } else {
            completion?("accel unavailable")
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        if (motionManager.isAccelerometerActive) {
            motionManager.stopAccelerometerUpdates()
        }
        completion?(nil)
    }
}
