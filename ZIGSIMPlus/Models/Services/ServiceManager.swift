//
//  StoreManager.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftOSC
import DeviceKit

protocol Service {
    func toLog() -> [String]
    func toOSC() -> [OSCMessage]
    func toJSON() -> [String:AnyObject]
}

/// ServiceManager creates OSC / JSON data and send it over TCP / UDP.
/// It also creates single string for output view.
///
/// This class does following things:
/// - Fetch data from services
/// - Merge them into single OSC / JSON data
/// - Add device data to it
/// - Send it over network with NetworkAdapter
class ServiceManager {
    static let shared = ServiceManager()
    private init() {}
    
    func send() {
        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            data = getOSC()
        }
        else {
            data = getJSON()
        }
        NetworkAdapter.shared.send(data)
    }

    public func getLog() -> String {
        var log = [String]()
        log += AltimeterService.shared.toLog()
        log += ArkitService.shared.toLog()
        log += AudioLevelService.shared.toLog()
        log += LocationService.shared.toLog()
        log += BatteryService.shared.toLog()
        log += MotionService.shared.toLog()
        log += ProximityService.shared.toLog()
        log += RemoteControlService.shared.toLog()
        log += TouchService.shared.toLog()
        return log.joined(separator: "\n")
    }
    
    private func getOSC() -> Data {
        let bundle = OSCBundle()
        let device = Device()

        // Default data
        let settings = AppSettingModel.shared
        bundle.add(OSCMessage(
            OSCAddressPattern("/\(settings.deviceUUID)/deviceinfo"),
            device.description,
            settings.deviceUUID,
            "ios",
            device.systemVersion,
            Int(Utils.screenWidth),
            Int(Utils.screenHeight)
        ))

        // Add data from stores
        bundle.elements += LocationService.shared.toOSC()
        bundle.elements += TouchService.shared.toOSC()
        bundle.elements += ArkitService.shared.toOSC()
        bundle.elements += RemoteControlService.shared.toOSC()
        bundle.elements += BatteryService.shared.toOSC()

        // TODO: Add timetag

        return bundle.data
    }

    private func getJSON() -> Data {
        var data = [String:AnyObject]()
        
        data.merge(LocationService.shared.toJSON()) { $1 }
        data.merge(TouchService.shared.toJSON()) { $1 }
        data.merge(ArkitService.shared.toJSON()) { $1 }
        data.merge(RemoteControlService.shared.toJSON()) { $1 }
        data.merge(BatteryService.shared.toJSON()) { $1 }

        let device = Device()
        
        return toJSON([
            "device": [
                "name": device.description,
                "uuid": AppSettingModel.shared.deviceUUID,
                "os": "ios",
                "osversion": device.systemVersion,
                "displaywidth": Int(Utils.screenWidth),
                "displayheight": Int(Utils.screenHeight),
            ] as AnyObject,
            "timestamp": Utils.getTimestamp() as AnyObject,
            "sensordata": data as AnyObject
        ])
    }
    
    private func toJSON(_ dic: Dictionary<String, AnyObject>)-> Data {
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        return jsonData
    }
}
