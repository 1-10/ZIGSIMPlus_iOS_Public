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

    static func send(accel: CMAccelerometerData) {
        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            data = OSCMessage(
                OSCAddressPattern("/\(AppSettingModel.shared.deviceUUID)/accel"),
                accel.acceleration.x,
                accel.acceleration.y,
                accel.acceleration.z
                ).data
        }
        else {
            var obj = Dictionary<String, AnyObject>()
            obj["accel"] = [
                "x": accel.acceleration.x,
                "y": accel.acceleration.y,
                "z": accel.acceleration.z,
                ] as AnyObject
            data = toJSON(obj)
        }
        NetworkAdapter.shared.send(data)
    }

    static func send(battery: Float) {
        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            data = OSCMessage(
                OSCAddressPattern("/\(AppSettingModel.shared.deviceUUID)/battery"),
                battery
            ).data
        }
        else {
            var obj = Dictionary<String, AnyObject>()
            obj["battery"] = battery as AnyObject
            data = toJSON(obj)
        }
        NetworkAdapter.shared.send(data)
    }

    static func send(touches: [UITouch]) {
        let deviceUUID = AppSettingModel.shared.deviceUUID

        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            let bundle = OSCBundle()

            for (i, touch) in touches.enumerated() {
                let point = touch.location(in: touch.view!)

                // Position
                bundle.add(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touch\(i)1"), Float(point.x)))
                bundle.add(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touch\(i)2"), Float(point.y)))

                if #available(iOS 8.0, *) {
                    bundle.add(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touchradius\(i)"), Float(touch.majorRadius)))
                }
                if #available(iOS 9.0, *) {
                    bundle.add(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touchforce\(i)"), Float(touch.force)))
                }
            }

            data = bundle.data
        }
        else {
            let objs: [Dictionary<String, CGFloat>] = touches.map { touch in
                let point = touch.location(in: touch.view!)
                var obj = ["x": point.x, "y": point.y]

                if #available(iOS 8.0, *) {
                    obj["radius"] = touch.majorRadius
                }
                if #available(iOS 9.0, *) {
                    obj["force"] = touch.force
                }

                return obj
            }
            data = toJSON(["touches": objs as AnyObject])
        }

        NetworkAdapter.shared.send(data)
    }

    static func send(gps: [Double]) {
        let deviceUUID = AppSettingModel.shared.deviceUUID

        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            data = OSCMessage(OSCAddressPattern("/\(deviceUUID)/gps"), gps[0], gps[1]).data
        }
        else {
            data = toJSON(["gps": gps as AnyObject])
        }

        NetworkAdapter.shared.send(data)
    }

    static func send(compass: Double) {
        let deviceUUID = AppSettingModel.shared.deviceUUID

        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            data = OSCMessage(OSCAddressPattern("/\(deviceUUID)/compass"), compass).data
        }
        else {
            data = toJSON(["compass": compass as AnyObject])
        }

        NetworkAdapter.shared.send(data)
    }

    static func send(beacons: [CLBeacon]) {
        let deviceUUID = AppSettingModel.shared.deviceUUID

        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            let bundle = OSCBundle()

            for (i, beacon) in beacons.enumerated() {
                bundle.add(OSCMessage(
                    OSCAddressPattern("/\(deviceUUID)/beacon\(i)"),
                    beacon.proximityUUID.uuidString,
                    beacon.major.intValue,
                    beacon.minor.intValue,
                    beacon.rssi
                ))
            }

            data = bundle.data
        }
        else {
            let objs: [Dictionary<String, Any>] = beacons.map { beacon in
                return [
                    "uuid": beacon.proximityUUID.uuidString,
                    "major": beacon.major.intValue,
                    "minor": beacon.minor.intValue,
                    "rssi": beacon.rssi
                ]
            }
            data = toJSON(["beacons": objs as AnyObject])
        }

        NetworkAdapter.shared.send(data)
    }

    static func toJSON(_ dic: Dictionary<String, AnyObject>)-> Data {
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        return jsonData
    }
}
