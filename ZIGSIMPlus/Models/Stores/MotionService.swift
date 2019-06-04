//
//  MotionDataService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/04.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import SwiftOSC

public class MotionService {
    // Singleton instance
    static let shared = MotionService()

    // MARK: - Instance Properties
    let motionManager = CMMotionManager()
    var accel: CMAcceleration = CMAcceleration()
    var gravity: CMAcceleration = CMAcceleration()
    var gyro: CMRotationRate = CMRotationRate()
    var quaternion: CMQuaternion = CMQuaternion()
    var isError: Bool = false

    func isAvailable() -> Bool {
        return motionManager.isDeviceMotionAvailable
    }

    func start() {
        if !motionManager.isDeviceMotionAvailable {
            isError = true
            return
        }

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (deviceMotion, error) in
            guard error == nil,
                let motion = deviceMotion else {
                    self.isError = true
                    return
            }

            // Save data
            self.accel = motion.userAcceleration
            self.gravity = motion.gravity
            self.gyro = motion.rotationRate
            self.quaternion = motion.attitude.quaternion
            self.isError = false
        }
    }

    func stop() {
        if !motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }
}

extension MotionService : Service {
    func toLog() -> [String] {
        var log = [String]()

        if isError {
            return [
                "motion unavailable"
            ]
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.acceleration]! {
            log += [
                "accel:x:\(accel.x)",
                "accel:y:\(accel.y)",
                "accel:z:\(accel.z)",
            ]
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.gravity]! {
            log += [
                "gravity:x:\(gravity.x)",
                "gravity:y:\(gravity.y)",
                "gravity:z:\(gravity.z)",
            ]
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.gyro]! {
            log += [
                "gyro:x:\(gyro.x)",
                "gyro:y:\(gyro.y)",
                "gyro:z:\(gyro.z)",
            ]
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.quaternion]! {
            log += [
                "quaternion:x:\(quaternion.x)",
                "quaternion:y:\(quaternion.y)",
                "quaternion:z:\(quaternion.z)",
                "quaternion:w:\(quaternion.w)",
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var messages = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommandData[Command.acceleration]! {
            messages.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/accel"),
                accel.x,
                accel.y,
                accel.z
            ))
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.gravity]! {
            messages.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/gravity"),
                gravity.x,
                gravity.y,
                gravity.z
            ))
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.gyro]! {
            messages.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/gyro"),
                gyro.x,
                gyro.y,
                gyro.z
            ))
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.quaternion]! {
            messages.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/quaternion"),
                quaternion.x,
                quaternion.y,
                quaternion.z,
                quaternion.w
            ))
        }

        return messages
    }

    func toJSON() -> [String:AnyObject] {
        var data = [String:AnyObject]()

        if AppSettingModel.shared.isActiveByCommandData[Command.acceleration]! {
            data.merge([
                "accel": [
                    "x": accel.x,
                    "y": accel.y,
                    "z": accel.z
                    ] as AnyObject
            ]) { $1 }
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.gravity]! {
            data.merge([
                "gravity": [
                    "x": gravity.x,
                    "y": gravity.y,
                    "z": gravity.z
                    ] as AnyObject
            ]) { $1 }
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.gyro]! {
            data.merge([
                "gyro": [
                    "x": gyro.x,
                    "y": gyro.y,
                    "z": gyro.z
                    ] as AnyObject
            ]) { $1 }
        }

        if AppSettingModel.shared.isActiveByCommandData[Command.quaternion]! {
            data.merge([
                "quaternion": [
                    "x": quaternion.x,
                    "y": quaternion.y,
                    "z": quaternion.z,
                    "w": quaternion.w
                    ] as AnyObject
            ]) { $1 }
        }

        return data
    }
}
