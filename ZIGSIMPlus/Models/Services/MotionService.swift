//
//  MotionDataService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/04.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import CoreMotion
import Foundation
import SwiftOSC
import SwiftyJSON
import UIKit

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

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { deviceMotion, error in
            guard error == nil,
                let motion = deviceMotion else {
                self.isError = true
                return
            }

            // Save data
            self.updateMotion(motion)
            self.isError = false
        }
    }

    func stop() {
        if !motionManager.isDeviceMotionAvailable {
            motionManager.stopDeviceMotionUpdates()
        }
    }

    func updateMotion(_ motion: CMDeviceMotion) {
        accel = motion.userAcceleration
        gravity = motion.gravity
        gyro = motion.rotationRate
        quaternion = motion.attitude.quaternion
    }
}

extension MotionService: Service {
    func toLog() -> [String] {
        var log = [String]()

        if isError {
            return [
                "motion unavailable",
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.acceleration]! {
            log += [
                "accel:x:\(accel.x)",
                "accel:y:\(accel.y)",
                "accel:z:\(accel.z)",
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.gravity]! {
            log += [
                "gravity:x:\(gravity.x)",
                "gravity:y:\(gravity.y)",
                "gravity:z:\(gravity.z)",
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.gyro]! {
            log += [
                "gyro:x:\(gyro.x)",
                "gyro:y:\(gyro.y)",
                "gyro:z:\(gyro.z)",
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.quaternion]! {
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
        var messages = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.acceleration]! {
            messages.append(osc("accel", accel.x, accel.y, accel.z))
        }

        if AppSettingModel.shared.isActiveByCommand[Command.gravity]! {
            messages.append(osc("gravity", gravity.x, gravity.y, gravity.z))
        }

        if AppSettingModel.shared.isActiveByCommand[Command.gyro]! {
            messages.append(osc("gyro", gyro.x, gyro.y, gyro.z))
        }

        if AppSettingModel.shared.isActiveByCommand[Command.quaternion]! {
            messages.append(osc("quaternion", quaternion.x, quaternion.y, quaternion.z, quaternion.w))
        }

        return messages
    }

    func toJSON() throws -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommand[Command.acceleration]! {
            data["accel"] = [
                "x": accel.x,
                "y": accel.y,
                "z": accel.z,
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.gravity]! {
            data["gravity"] = [
                "x": gravity.x,
                "y": gravity.y,
                "z": gravity.z,
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.gyro]! {
            data["gyro"] = [
                "x": gyro.x,
                "y": gyro.y,
                "z": gyro.z,
            ]
        }

        if AppSettingModel.shared.isActiveByCommand[Command.quaternion]! {
            data["quaternion"] = [
                "x": quaternion.x,
                "y": quaternion.y,
                "z": quaternion.z,
                "w": quaternion.w,
            ]
        }

        return data
    }
}
