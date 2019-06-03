//
//  StoreManagerTests.swift
//  ZIGSIMPlusTests
//
//  Created by Takayosi Amagi on 2019/06/03.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import XCTest
@testable import ZIGSIMPlus

class StoreManagerTests: XCTestCase {
    // Test if JSON includes device data
    func test_getJSON_device() {
        let json = StoreManager.shared.getJSON()
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
        let labelsAndKeys: [Label:String] = [
            .pressure: "pressure", // AltimeterDataStore
            .arkit: "arkit", // ArkitDataStore
            .micLevel: "miclevel", // AudioLevelDataStore
            .gps: "gps", // LocationDataStore
            .acceleration: "accel", // MiscDataStore
            .proximity: "proximitymonitor", // ProximityDataStore
            .remoteControl: "remoteControl", // RemoteControlDataStore
            .touch: "touches", // TouchDataStore
        ]

        labelsAndKeys.forEach { (label, key) in
            AppSettingModel.shared.isActiveByCommandData[label] = true
            let json = StoreManager.shared.getJSON()
            XCTAssert(json["sensordata"][key].exists(), "Sensordata for \(label) is stored as  \(key)")
            AppSettingModel.shared.isActiveByCommandData[label] = false
        }
    }
}
