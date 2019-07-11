//
//  ServiceManagerTests.swift
//  ZIGSIMPlusTests
//
//  Created by Takayosi Amagi on 2019/06/03.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import SwiftOSC
import XCTest
@testable import ZIGSIMPlus

// swiftlint:disable force_cast

class ServiceManagerTests: XCTestCase {
    // Test if OSC includes device data
    func test_getOSC_device() {
        let osc = ServiceManager.shared.getOSC()
        XCTAssert(type(of: osc) == OSCBundle.self, "getOSC returns OSCBundle")

        // Find diviceinfo message in bundle
        for element in osc.elements {
            let message = element as! OSCMessage
            let addr = message.address.string

            if !addr.contains("/deviceinfo") {
                let args = message.arguments
                XCTAssert(type(of: args[0]!) == String.self, "args[0] is device name")
                XCTAssertEqual(args[1]! as! String, AppSettingModel.shared.deviceUUID, "args[1] is device uuid")
                XCTAssertEqual(args[2]! as! String, "ios", "args[2] is ios/android")
                XCTAssert(type(of: args[3]!) == String.self, "args[3] is system version")
                XCTAssert(type(of: args[4]!) == Int.self, "args[4] is screen width")
                XCTAssert(type(of: args[5]!) == Int.self, "args[5] is screen height")
                break
            }
        }
    }

    // Test if OSC includes data from Stores
    func test_getOSC_keys() {
        let commandsAndKeys: [Command: String] = [
            .pressure: "pressure", // AltimeterDataStore
            .arkit: "arkit", // ArkitDataStore
            .micLevel: "miclevel", // AudioLevelDataStore
            .gps: "gps", // LocationDataStore
            .acceleration: "accel", // MiscDataStore
            .proximity: "proximitymonitor", // ProximityDataStore
            .remoteControl: "remotecontrol", // RemoteControlDataStore

            // TouchDataStore data is not sent until the device is touched
            // .touch: "touch01", // TouchDataStore
        ]

        commandsAndKeys.forEach { command, key in
            AppSettingModel.shared.isActiveByCommand[command] = true
            let osc = ServiceManager.shared.getOSC()

            // Find relevant message in OSC bundle
            let msg = osc.elements.first { element in
                let message = element as! OSCMessage
                let addr = message.address.string
                return addr.contains(key)
            }

            XCTAssert(msg != nil, "Sensordata for \(command) is sent to \(key)")

            AppSettingModel.shared.isActiveByCommand[command] = false
        }
    }

    // Test if JSON includes device data
    func test_getJSON_device() {
        let json = ServiceManager.shared.getJSON()
        XCTAssert(json["device"].exists())

        // Test device info
        let device = json["device"]
        XCTAssert(device["name"].type == .string)
        XCTAssertEqual(device["uuid"].string, AppSettingModel.shared.deviceUUID)
        XCTAssertEqual(device["os"].string, "ios")
        XCTAssert(device["osversion"].type == .string)
        XCTAssert(device["displaywidth"].type == .number)
        XCTAssert(device["displayheight"].type == .number)
    }

    // Test if JSON includes data from Stores
    func test_getJSON_keys() {
        let commandsAndKeys: [Command: String] = [
            .pressure: "pressure", // AltimeterDataStore
            .arkit: "arkit", // ArkitDataStore
            .micLevel: "miclevel", // AudioLevelDataStore
            .gps: "gps", // LocationDataStore
            .acceleration: "accel", // MiscDataStore
            .proximity: "proximitymonitor", // ProximityDataStore
            .remoteControl: "remoteControl", // RemoteControlDataStore
            .touch: "touches", // TouchDataStore
        ]

        commandsAndKeys.forEach { command, key in
            AppSettingModel.shared.isActiveByCommand[command] = true
            let json = ServiceManager.shared.getJSON()
            XCTAssert(json["sensordata"][key].exists(), "Sensordata for \(command) is stored as \(key)")
            AppSettingModel.shared.isActiveByCommand[command] = false
        }
    }
}
