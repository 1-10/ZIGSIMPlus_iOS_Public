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

protocol Store {
    func toLog() -> [String]
    func toOSC() -> [OSCMessage]
    func toJSON() -> [String:AnyObject]
}

/// StoreManager creates OSC / JSON data and send it over TCP / UDP.
///
/// This class does following things:
/// - Fetch data from stores
/// - Merge them into single OSC / JSON data
/// - Add device data to it
/// - Send it over network with NetworkAdapter
class StoreManager {
    static let shared = StoreManager()
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
        log += AltimeterDataStore.shared.toLog()
        log += ArkitDataStore.shared.toLog()
        log += AudioLevelDataStore.shared.toLog()
        log += LocationDataStore.shared.toLog()
        log += MiscDataStore.shared.toLog()
        log += ProximityDataStore.shared.toLog()
        log += RemoteControlDataStore.shared.toLog()
        log += TouchDataStore.shared.toLog()
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
        bundle.elements += LocationDataStore.shared.toOSC()
        bundle.elements += TouchDataStore.shared.toOSC()
        bundle.elements += ArkitDataStore.shared.toOSC()
        bundle.elements += RemoteControlDataStore.shared.toOSC()
        bundle.elements += MiscDataStore.shared.toOSC()

        // TODO: Add timetag

        return bundle.data
    }

    private func getJSON() -> Data {
        var data = [String:AnyObject]()
        
        data.merge(LocationDataStore.shared.toJSON()) { $1 }
        data.merge(TouchDataStore.shared.toJSON()) { $1 }
        data.merge(ArkitDataStore.shared.toJSON()) { $1 }
        data.merge(RemoteControlDataStore.shared.toJSON()) { $1 }
        data.merge(MiscDataStore.shared.toJSON()) { $1 }

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
