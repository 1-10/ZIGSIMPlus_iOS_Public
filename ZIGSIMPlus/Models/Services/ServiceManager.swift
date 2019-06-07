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

protocol Service {
    func toLog() -> [String]
    func toOSC() -> [OSCMessage]
    func toJSON() throws -> JSON
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
        log += NFCService.shared.toLog()
        return log.joined(separator: "\n")
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
        bundle.elements += AltimeterService.shared.toOSC()
        bundle.elements += ArkitService.shared.toOSC()
        bundle.elements += AudioLevelService.shared.toOSC()
        bundle.elements += LocationService.shared.toOSC()
        bundle.elements += MotionService.shared.toOSC()
        bundle.elements += BatteryService.shared.toOSC()
        bundle.elements += ProximityService.shared.toOSC()
        bundle.elements += RemoteControlService.shared.toOSC()
        bundle.elements += TouchService.shared.toOSC()
        bundle.elements += NFCService.shared.toOSC()

        // TODO: Add timetag

        return bundle
    }

    public func getJSON() -> JSON {
        var data = JSON()

        do {
            try data.merge(with: AltimeterService.shared.toJSON())
            try data.merge(with: ArkitService.shared.toJSON())
            try data.merge(with: AudioLevelService.shared.toJSON())
            try data.merge(with: LocationService.shared.toJSON())
            try data.merge(with: MotionService.shared.toJSON())
            try data.merge(with: BatteryService.shared.toJSON())
            try data.merge(with: ProximityService.shared.toJSON())
            try data.merge(with: RemoteControlService.shared.toJSON())
            try data.merge(with: TouchService.shared.toJSON())
            try data.merge(with: NFCService.shared.toJSON())
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