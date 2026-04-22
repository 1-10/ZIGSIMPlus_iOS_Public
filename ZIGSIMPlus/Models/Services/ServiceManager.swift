//
//  StoreManager.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import DeviceKit
import Foundation
import os.log
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
    private static let log = OSLog(
        subsystem: Bundle.main.bundleIdentifier ?? "com.zigsim",
        category: "ServiceManager"
    )
    private init() {}

    public func getData() -> Data {
        let data: Data

        if AppSettingModel.shared.transportFormat == .OSC {
            let osc = getOSC()
            data = (try? OSCPacket.bundle(osc).rawData()) ?? Data()
            #if DEBUG
                logOSCPacketBytes(data)
            #endif
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
        var bundle = OSCBundle()
        let device = Device.current
        // Default data
        let settings = AppSettingModel.shared
        bundle.elements.append(.message(OSCMessage(
            "/\(settings.deviceUUID)/deviceinfo",
            values: [
                device.description,
                settings.deviceUUID,
                "ios",
                device.systemVersion ?? "",
                Int(Utils.screenWidth),
                Int(Utils.screenHeight),
            ]
        )))

        // Add data from stores
        bundle.elements += AltimeterService.shared.toOSC().map { .message($0) }
        bundle.elements += ArkitService.shared.toOSC().map { .message($0) }
        bundle.elements += AudioLevelService.shared.toOSC().map { .message($0) }
        bundle.elements += LocationService.shared.toOSC().map { .message($0) }
        bundle.elements += MotionService.shared.toOSC().map { .message($0) }
        bundle.elements += BatteryService.shared.toOSC().map { .message($0) }
        bundle.elements += ProximityService.shared.toOSC().map { .message($0) }
        bundle.elements += RemoteControlService.shared.toOSC().map { .message($0) }
        bundle.elements += TouchService.shared.toOSC().map { .message($0) }
        bundle.elements += VideoCaptureService.shared.toOSC().map { .message($0) }
        bundle.elements += NFCService.shared.toOSC().map { .message($0) }

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

    #if DEBUG
        private func logOSCPacketBytes(_ data: Data) {
            os_log(
                "OSC bundle bytes: size=%{public}d",
                log: Self.log,
                type: .debug,
                data.count
            )

            for offset in stride(from: 0, to: data.count, by: 16) {
                let lineBytes = data[offset..<min(offset + 16, data.count)]
                let hexDump = lineBytes.enumerated()
                    .map { index, byte in
                        index == 8
                            ? " " + String(format: "%02x", byte)
                            : String(format: "%02x", byte)
                    }
                    .joined(separator: " ")

                os_log(
                    "[OSCBundle] %{public}@",
                    log: Self.log,
                    type: .debug,
                    String(format: "%08x: %@", offset, hexDump)
                )
            }
        }
    #endif
}
