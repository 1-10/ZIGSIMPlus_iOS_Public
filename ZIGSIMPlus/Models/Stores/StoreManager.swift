//
//  StoreManager.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftOSC
import SwiftyJSON
import DeviceKit

protocol Store {
    func toOSC() -> [OSCMessage]
    func toJSON() throws -> JSON
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
    
    public func send() {
        let data: Data
        if AppSettingModel.shared.transportFormat == .OSC {
            let osc = getOSC()
            data = osc.data
        }
        else {
            let json = getJSON()
            data = try! json.rawData()
        }
        NetworkAdapter.shared.send(data)
    }
    
    public func getOSC() -> OSCBundle {
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

        return bundle
    }

    public func getJSON() -> JSON {
        var data = JSON()

        do {
            try data.merge(with: LocationDataStore.shared.toJSON())
            try data.merge(with: TouchDataStore.shared.toJSON())
            try data.merge(with: ArkitDataStore.shared.toJSON())
            try data.merge(with: RemoteControlDataStore.shared.toJSON())
            try data.merge(with: MiscDataStore.shared.toJSON())
        } catch {
            print(">> JSON convert error")
        }

        let device = Device()
        
        return JSON([
            "device": [
                "name": device.description,
                "uuid": AppSettingModel.shared.deviceUUID,
                "os": "ios",
                "osversion": device.systemVersion,
                "displaywidth": Int(Utils.screenWidth),
                "displayheight": Int(Utils.screenHeight),
            ],
            "timestamp": Utils.getTimestamp(),
            "sensordata": data
        ])
    }
}
