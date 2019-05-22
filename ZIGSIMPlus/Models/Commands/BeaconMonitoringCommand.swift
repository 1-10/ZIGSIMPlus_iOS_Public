//
//  BeaconMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class BeaconMonitoringCommand: AutoUpdatedCommand {
    
    public func start(completion: ((String?) -> Void)?) {
//        if motionManager.isAccelerometerAvailable {
        if true {
//            motionManager.accelerometerUpdateInterval = AppSettingModel.shared.messageInterval
//            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerationData, error) in
//                guard error == nil else {
//                    completion?(error!.localizedDescription)
//                    return
//                }
//
//                guard let accelData = accelerationData else {
//                    completion?("no accel data")
//                    return
//                }
//
//                completion?("""
//                    accel:x:\(accelData.acceleration.x)
//                    accel:y:\(accelData.acceleration.y)
//                    accel:z:\(accelData.acceleration.z)
//                    """)
//            }
            completion?("woooooooooooooo")
        } else {
            completion?("accel unavailable")
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
//        if (motionManager.isAccelerometerActive) {
//            motionManager.stopAccelerometerUpdates()
//        }
        completion?(nil)
    }
}
