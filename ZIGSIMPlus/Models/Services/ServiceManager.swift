//
//  StoreManager.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import DeviceKit
import Foundation
import OSCKit
import SwiftyJSON

/// ServiceManager creates OSC / JSON data.
/// It also creates single string for output view.
///
/// This class does following things:
/// - Fetch data from services
/// - Merge them into single OSC / JSON data
/// - Add device data to it
class ServiceManager {
    static let shared = ServiceManager()
    private init() {}

    public func getData() -> Data {
        let data: Data

        if AppSettingModel.shared.transportFormat == .OSC {
            let osc = getOSC()
            data = (try? osc.rawData()) ?? Data()
        } else {
            let json = getJSON()
            data = (try? json.rawData()) ?? Data()
        }

        return data
    }

    public func getString() -> String {
        if AppSettingModel.shared.transportFormat == .OSC {
            let osc = getOSC()
            return osc.getString()
        } else {
            let json = getJSON()
            return (json.rawString(.utf8, options: []) ?? "") + "\n"
        }
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
        log += VideoCaptureService.shared.toLog()
        log += NFCService.shared.toLog()
        return log.joined(separator: "\n")
    }

    public func getOSC() -> OSCBundle {
        let device = Device.current
        let settings = AppSettingModel.shared

        // Default data
        let deviceInfo = OSCMessage(
            "/\(settings.deviceUUID)/deviceinfo",
            values: [
                device.description,
                settings.deviceUUID,
                "ios",
                device.systemVersion ?? "",
                Int32(Utils.screenWidth),
                Int32(Utils.screenHeight),
            ]
        )

        // Collect messages from all services
        var messages: [OSCMessage] = [deviceInfo]
        messages += AltimeterService.shared.toOSC()
        messages += ArkitService.shared.toOSC()
        messages += AudioLevelService.shared.toOSC()
        messages += LocationService.shared.toOSC()
        messages += MotionService.shared.toOSC()
        messages += BatteryService.shared.toOSC()
        messages += ProximityService.shared.toOSC()
        messages += RemoteControlService.shared.toOSC()
        messages += TouchService.shared.toOSC()
        messages += VideoCaptureService.shared.toOSC()
        messages += NFCService.shared.toOSC()

        // TODO: Add timetag

        return OSCBundle(messages.map { .message($0) })
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
            try data.merge(with: VideoCaptureService.shared.toJSON())
            try data.merge(with: NFCService.shared.toJSON())
        } catch {
            print(">> JSON convert error")
        }

        let device = Device.current

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
            "sensordata": data,
        ])
    }

    public func getErrorLog() -> String? {
        var log = [String]()

        if let l = NetworkAdapter.shared.getErrorLog() {
            log.append(l)
        }

        return log.count == 0 ? nil : log.joined(separator: "\n")
    }
}
