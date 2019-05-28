//
//  StoreManager.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftOSC

protocol Store {
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
    
    private func getOSC() -> Data {
        let bundle = OSCBundle()
        
        // Default data
        let settings = AppSettingModel.shared
        bundle.add(OSCMessage(
            OSCAddressPattern("/\(settings.deviceUUID)/deviceinfo"),
            "__DEVICE_NAME__", // TODO: Replace with correct deviceName
            settings.deviceUUID,
            "ios",
            12.2, // TBD
            Utils.screenWidth,
            Utils.screenHeight
        ))

        // Add data from stores
        bundle.elements += LocationDataStore.shared.toOSC()
        bundle.elements += TouchDataStore.shared.toOSC()
        bundle.elements += MiscDataStore.shared.toOSC()

        return bundle.data
    }

    private func getJSON() -> Data {
        var data = [String:AnyObject]()
        
        data.merge(LocationDataStore.shared.toJSON()) { $1 }
        data.merge(TouchDataStore.shared.toJSON()) { $1 }
        data.merge(MiscDataStore.shared.toJSON()) { $1 }

        return toJSON([
            "device": [
                "name": "__DEVICE_NAME__", // TBD
                "uuid": AppSettingModel.shared.deviceUUID,
                "os": "ios",
                "osversion": "12.2", // TBD
                "displaywidth": Utils.screenWidth,
                "displayheight": Utils.screenHeight,
            ] as AnyObject,
            "timestamp": "2019_05_23_18:24:02.471" as AnyObject, // TBD
            "sensordata": data as AnyObject
        ])
    }
    
    private func toJSON(_ dic: Dictionary<String, AnyObject>)-> Data {
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        return jsonData
    }
}
