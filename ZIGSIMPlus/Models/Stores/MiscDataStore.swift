//
//  MiscDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import SwiftOSC

public class MiscDataStore {
    // Singleton instance
    static let shared = MiscDataStore()
    private init() {}
    
    // MARK: - Instance Properties
    
    var battery: Float = 0.0
    var accel: CMAcceleration = CMAcceleration()
    var gravity: CMAcceleration = CMAcceleration()
    var gyro: CMRotationRate = CMRotationRate()
//    var rotation: CMRotationRate = CMRotationRate()
    var quaternion: CMQuaternion = CMQuaternion()
}

extension MiscDataStore : Store {
    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var messages = [OSCMessage]()
        
        if AppSettingModel.shared.isActiveByCommandData[LabelConstants.battery]! {
            messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/battery"), battery))
        }
        
        if AppSettingModel.shared.isActiveByCommandData[LabelConstants.acceleration]! {
            messages.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/accel"),
                accel.x,
                accel.y,
                accel.z
            ))
        }
        
        return messages
    }
    
    func toJSON() -> [String:AnyObject] {
        var data = [String:AnyObject]()

        if AppSettingModel.shared.isActiveByCommandData[LabelConstants.battery]! {
            data.merge(["battery": battery as AnyObject]) { $1 }
        }
        
        if AppSettingModel.shared.isActiveByCommandData[LabelConstants.acceleration]! {
            data.merge([
                "accel": [
                    "x": accel.x,
                    "y": accel.y,
                    "z": accel.z
                ] as AnyObject
            ]) { $1 }
        }

        return data
    }
}
