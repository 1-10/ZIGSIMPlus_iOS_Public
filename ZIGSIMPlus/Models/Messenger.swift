//
//  Messenger.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion
import CoreLocation
import SwiftOSC

/// Messenger takes care of messaging from commands.
///
/// This class does 3 things inside:
/// - Convert messages to binary
/// - Queue messages and bundle (TBD)
/// - Send data with NetworkAdapter
class Messenger {
    let shared = Messenger()
    private init() {}

//    static func send(accel: CMAccelerometerData) {
//        let data: Data
//        if AppSettingModel.shared.transportFormat == .OSC {
//            data = OSCMessage(
//                OSCAddressPattern("/\(AppSettingModel.shared.deviceUUID)/accel"),
//                accel.acceleration.x,
//                accel.acceleration.y,
//                accel.acceleration.z
//                ).data
//        }
//        else {
//            var obj = Dictionary<String, AnyObject>()
//            obj["accel"] = [
//                "x": accel.acceleration.x,
//                "y": accel.acceleration.y,
//                "z": accel.acceleration.z,
//                ] as AnyObject
//            data = toJSON(obj)
//        }
//        NetworkAdapter.shared.send(data)
//    }
//
//    static func send(battery: Float) {
//        let data: Data
//        if AppSettingModel.shared.transportFormat == .OSC {
//            data = OSCMessage(
//                OSCAddressPattern("/\(AppSettingModel.shared.deviceUUID)/battery"),
//                battery
//            ).data
//        }
//        else {
//            var obj = Dictionary<String, AnyObject>()
//            obj["battery"] = battery as AnyObject
//            data = toJSON(obj)
//        }
//        NetworkAdapter.shared.send(data)
//    }
}
