//
//  MotionServiceTests.swift
//  ZIGSIMPlusTests
//
//  Created by Takayosi Amagi on 2019/06/14.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import CoreMotion
import SwiftOSC
import SwiftyJSON
import XCTest
@testable import ZIGSIMPlus

// swiftlint:disable force_cast force_try identifier_name

class AttitudeMock: CMAttitude {
    var _quaternion: CMQuaternion?

    init(_ quaternion: CMQuaternion) {
        super.init()
        _quaternion = quaternion
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var quaternion: CMQuaternion { return _quaternion! }
}

class MotionMock: CMDeviceMotion {
    var _userAcceleration: CMAcceleration?
    var _gravity: CMAcceleration?
    var _rotationRate: CMRotationRate?
    var _attitude: CMAttitude?

    init(_ accel: CMAcceleration, _ gravity: CMAcceleration, _ gyro: CMRotationRate, _ quaternion: CMQuaternion) {
        _userAcceleration = accel
        _gravity = gravity
        _rotationRate = gyro
        _attitude = AttitudeMock(quaternion)
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var userAcceleration: CMAcceleration { return _userAcceleration! }

    override var gravity: CMAcceleration { return _gravity! }

    override var rotationRate: CMRotationRate { return _rotationRate! }

    override var attitude: CMAttitude { return _attitude! }
}

class MotionServiceTests: XCTestCase {
    // Test if OSC includes device data
    func test_toOSC_empty() {
        AppSettingModel.shared.isActiveByCommand[.acceleration] = false
        let osc = MotionService.shared.toOSC()
        XCTAssertEqual(osc.count, 0, "No messages")
    }

    func test_toOSC() {
        let motion = MotionMock(
            CMAcceleration(x: 1, y: 2, z: 3),
            CMAcceleration(x: 4, y: 5, z: 6),
            CMRotationRate(x: 1, y: 2, z: 3),
            CMQuaternion(x: 1, y: 2, z: 3, w: 4)
        )
        MotionService.shared.updateMotion(motion)

        // Acceleration
        AppSettingModel.shared.isActiveByCommand[.acceleration] = true
        var osc = MotionService.shared.toOSC()
        XCTAssertEqual(osc.count, 1, "Only 1 message")
        XCTAssert(osc[0].address.string.contains("/accel"), "0th message is accel")
        XCTAssertEqual(osc[0].arguments as! [Double], [1.0, 2.0, 3.0], "accel is correct")
        AppSettingModel.shared.isActiveByCommand[.acceleration] = false

        // Gravity
        AppSettingModel.shared.isActiveByCommand[.gravity] = true
        osc = MotionService.shared.toOSC()
        XCTAssertEqual(osc.count, 1, "Only 1 message")
        XCTAssert(osc[0].address.string.contains("/gravity"), "0th message is gravity")
        XCTAssertEqual(osc[0].arguments as! [Double], [4.0, 5.0, 6.0], "gravity is correct")
        AppSettingModel.shared.isActiveByCommand[.gravity] = false

        // Gyro
        AppSettingModel.shared.isActiveByCommand[.gyro] = true
        osc = MotionService.shared.toOSC()
        XCTAssertEqual(osc.count, 1, "Only 1 message")
        XCTAssert(osc[0].address.string.contains("/gyro"), "0th message is gyro")
        XCTAssertEqual(osc[0].arguments as! [Double], [1.0, 2.0, 3.0], "gyro is correct")
        AppSettingModel.shared.isActiveByCommand[.gyro] = false

        // Quaternion
        AppSettingModel.shared.isActiveByCommand[.quaternion] = true
        osc = MotionService.shared.toOSC()
        XCTAssertEqual(osc.count, 1, "Only 1 message")
        XCTAssert(osc[0].address.string.contains("/quaternion"), "0th message is quaternion")
        XCTAssertEqual(osc[0].arguments as! [Double], [1.0, 2.0, 3.0, 4.0], "quaternion is correct")
        AppSettingModel.shared.isActiveByCommand[.quaternion] = false
    }

    func test_toJSON_empty() {
        AppSettingModel.shared.isActiveByCommand[.acceleration] = false
        let json = try! MotionService.shared.toJSON()
        XCTAssertEqual(json, JSON([:]), "Empty JSON")
    }

    func test_toJSON() {
        let motion = MotionMock(
            CMAcceleration(x: 1, y: 2, z: 3),
            CMAcceleration(x: 4, y: 5, z: 6),
            CMRotationRate(x: 1, y: 2, z: 3),
            CMQuaternion(x: 1, y: 2, z: 3, w: 4)
        )
        MotionService.shared.updateMotion(motion)

        // Acceleration
        AppSettingModel.shared.isActiveByCommand[.acceleration] = true
        var json = try! MotionService.shared.toJSON()
        var exp = [
            "accel": [
                "x": 1.0, "y": 2.0, "z": 3.0,
            ],
        ]
        XCTAssertEqual(json, JSON(exp), "accel all")
        AppSettingModel.shared.isActiveByCommand[.acceleration] = false

        // Gravity
        AppSettingModel.shared.isActiveByCommand[.gravity] = true
        json = try! MotionService.shared.toJSON()
        exp = [
            "gravity": [
                "x": 4.0, "y": 5.0, "z": 6.0,
            ],
        ]
        XCTAssertEqual(json, JSON(exp), "gravity all")
        AppSettingModel.shared.isActiveByCommand[.gravity] = false

        // Gyro
        AppSettingModel.shared.isActiveByCommand[.gyro] = true
        json = try! MotionService.shared.toJSON()
        exp = [
            "gyro": [
                "x": 1.0, "y": 2.0, "z": 3.0,
            ],
        ]
        XCTAssertEqual(json, JSON(exp), "gyro all")
        AppSettingModel.shared.isActiveByCommand[.gyro] = false

        // Quaternion
        AppSettingModel.shared.isActiveByCommand[.quaternion] = true
        json = try! MotionService.shared.toJSON()
        exp = [
            "quaternion": [
                "x": 1.0, "y": 2.0, "z": 3.0, "w": 4.0,
            ],
        ]
        XCTAssertEqual(json, JSON(exp), "quaternion all")
        AppSettingModel.shared.isActiveByCommand[.quaternion] = false
    }

    func test_toLog_empty() {
        AppSettingModel.shared.isActiveByCommand[.acceleration] = false
        let log = MotionService.shared.toLog()
        XCTAssertEqual(log, [], "Empty log")
    }

    func test_toLog() {
        let motion = MotionMock(
            CMAcceleration(x: 1, y: 2, z: 3),
            CMAcceleration(x: 4, y: 5, z: 6),
            CMRotationRate(x: 1, y: 2, z: 3),
            CMQuaternion(x: 1, y: 2, z: 3, w: 4)
        )
        MotionService.shared.updateMotion(motion)

        // Acceleration
        AppSettingModel.shared.isActiveByCommand[.acceleration] = true
        var log = MotionService.shared.toLog()
        XCTAssertEqual(log.count, 3, "3 messages for acceleration")
        XCTAssertEqual(log[0], "accel:x:1.0", "log[0] is x")
        XCTAssertEqual(log[1], "accel:y:2.0", "log[1] is y")
        XCTAssertEqual(log[2], "accel:z:3.0", "log[2] is z")
        AppSettingModel.shared.isActiveByCommand[.acceleration] = false

        // Gravity
        AppSettingModel.shared.isActiveByCommand[.gravity] = true
        log = MotionService.shared.toLog()
        XCTAssertEqual(log.count, 3, "3 messages for gravity")
        XCTAssertEqual(log[0], "gravity:x:4.0", "log[0] is x")
        XCTAssertEqual(log[1], "gravity:y:5.0", "log[1] is y")
        XCTAssertEqual(log[2], "gravity:z:6.0", "log[2] is z")
        AppSettingModel.shared.isActiveByCommand[.gravity] = false

        // Gyro
        AppSettingModel.shared.isActiveByCommand[.gyro] = true
        log = MotionService.shared.toLog()
        XCTAssertEqual(log.count, 3, "3 messages for gyro")
        XCTAssertEqual(log[0], "gyro:x:1.0", "log[0] is x")
        XCTAssertEqual(log[1], "gyro:y:2.0", "log[1] is y")
        XCTAssertEqual(log[2], "gyro:z:3.0", "log[2] is z")
        AppSettingModel.shared.isActiveByCommand[.gyro] = false

        // Quaternion
        AppSettingModel.shared.isActiveByCommand[.quaternion] = true
        log = MotionService.shared.toLog()
        XCTAssertEqual(log.count, 4, "4 messages for quaternion")
        XCTAssertEqual(log[0], "quaternion:x:1.0", "log[0] is x")
        XCTAssertEqual(log[1], "quaternion:y:2.0", "log[1] is y")
        XCTAssertEqual(log[2], "quaternion:z:3.0", "log[2] is z")
        XCTAssertEqual(log[3], "quaternion:w:4.0", "log[3] is w")
        AppSettingModel.shared.isActiveByCommand[.quaternion] = false
    }
}
