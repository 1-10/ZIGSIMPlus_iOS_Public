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
            "ios"
        ))

        // Add data from stores
        bundle.elements += LocationDataStore.shared.toOSC()
        bundle.elements += GpsCompassData.shared.toOSC()
        bundle.elements += TouchDataStore.shared.toOSC()

        return bundle.data
    }

    private func getJSON() -> Data {
        var data = [String:AnyObject]()
        
        data.merge([
            "device": [
                "name": "__DEVICE_NAME__",
                "uuid": AppSettingModel.shared.deviceUUID,
                "os": "ios",
                "osversion": "12.2",
                "displaywidth": 1125,
                "displayheight": 2001,
            ]
        ] as [String:AnyObject]) { (_, new) in new }
        
        data.merge(LocationDataStore.shared.toJSON()) { (_, new) in new }
        data.merge(TouchDataStore.shared.toJSON()) { (_, new) in new }
        data.merge(GpsCompassData.shared.toJSON()) { (_, new) in new }

        return toJSON(data)
    }
    
    private func toJSON(_ dic: Dictionary<String, AnyObject>)-> Data {
        let jsonData = try! JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions(rawValue: 0))
        return jsonData
    }
}
