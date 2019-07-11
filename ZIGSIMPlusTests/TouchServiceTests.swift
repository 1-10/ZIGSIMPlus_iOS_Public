//
//  TouchServiceTests.swift
//  ZIGSIMPlusTests
//
//  Created by Takayosi Amagi on 2019/06/13.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import SwiftOSC
import SwiftyJSON
import XCTest
@testable import ZIGSIMPlus

// swiftlint:disable force_cast function_body_length force_try identifier_name

/// UITouch with public setter for position, radius, force
class UITouchMock: UITouch {
    var _x: Int = 0
    var _y: Int = 0
    var _radius: CGFloat = 0.0
    var _force: CGFloat = 0.0

    init(_ x: Int, _ y: Int, _ radius: CGFloat, _ force: CGFloat) {
        super.init()
        _x = x
        _y = y
        _radius = radius
        _force = force
    }

    func update(_ x: Int, _ y: Int, _ radius: CGFloat, _ force: CGFloat) {
        _x = x
        _y = y
        _radius = radius
        _force = force
    }

    override var view: UIView? { return UIView() }

    override func location(in _: UIView?) -> CGPoint {
        return CGPoint(x: _x, y: _y)
    }

    override var majorRadius: CGFloat { return _radius }

    override var force: CGFloat { return _force }
}

class TouchServiceTests: XCTestCase {
    // Test if OSC includes device data
    func test_toOSC_empty() {
        AppSettingModel.shared.isActiveByCommand[.touch] = false
        let osc = TouchService.shared.toOSC()
        XCTAssertEqual(osc.count, 0, "No messages")
    }

    func test_toOSC_notouch() {
        AppSettingModel.shared.isActiveByCommand[.touch] = true
        let osc = TouchService.shared.toOSC()
        XCTAssertEqual(osc.count, 0, "No messages")
    }

    func test_toOSC() {
        AppSettingModel.shared.isActiveByCommand[.touch] = true
        TouchService.shared.enable()

        let tWidth = 100
        let tHeight = 100
        TouchService.shared.setTouchArea(rect: CGRect(x: 0, y: 0, width: tWidth, height: tHeight))

        var touches: [UITouchMock] = [
            UITouchMock(12, 34, 0.1, 0.2),
            UITouchMock(56, 78, 0.3, 0.4),
        ]
        TouchService.shared.addTouches(touches)

        var osc = TouchService.shared.toOSC()
        XCTAssertEqual(osc.count, 8, "TouchService returns 4 messages per touch")

        for (i, t) in touches.enumerated() {
            let ii = i * 4
            XCTAssert(osc[ii + 0].address.string.contains("/touch\(i)1"), "osc[\(ii + 0)] is x position")
            XCTAssert(osc[ii + 1].address.string.contains("/touch\(i)2"), "osc[\(ii + 1)] is y position")
            XCTAssert(osc[ii + 2].address.string.contains("/touchradius\(i)"), "osc[\(ii + 2)] is radius")
            XCTAssert(osc[ii + 3].address.string.contains("/touchforce\(i)"), "osc[\(ii + 3)] is force")

            let x = Float(t._x) / Float(tWidth) * 2 - 1
            let y = Float(t._y) / Float(tHeight) * 2 - 1
            XCTAssertLessThan(abs(osc[ii + 0].arguments[0]! as! Float - x), 0.01, "x is almost correct")
            XCTAssertLessThan(abs(osc[ii + 1].arguments[0]! as! Float - y), 0.01, "y is almost correct")
            XCTAssertEqual(osc[ii + 2].arguments[0]! as! Float, Float(t._radius), "radius is correct")
            XCTAssertEqual(osc[ii + 3].arguments[0]! as! Float, Float(t._force), "force is correct")
        }

        // Test updateTouches
        touches[0].update(23, 45, 0.5, 0.6)
        touches[1].update(67, 89, 0.7, 0.8)
        TouchService.shared.updateTouches(touches)

        osc = TouchService.shared.toOSC()
        XCTAssertEqual(osc.count, 8, "TouchService returns 4 messages per touch")

        for (i, t) in touches.enumerated() {
            let ii = i * 4
            XCTAssert(osc[ii + 0].address.string.contains("/touch\(i)1"), "osc[\(ii + 0)] is x position")
            XCTAssert(osc[ii + 1].address.string.contains("/touch\(i)2"), "osc[\(ii + 1)] is y position")
            XCTAssert(osc[ii + 2].address.string.contains("/touchradius\(i)"), "osc[\(ii + 2)] is radius")
            XCTAssert(osc[ii + 3].address.string.contains("/touchforce\(i)"), "osc[\(ii + 3)] is force")

            let x = Float(t._x) / Float(tWidth) * 2 - 1
            let y = Float(t._y) / Float(tHeight) * 2 - 1
            XCTAssertLessThan(abs(osc[ii + 0].arguments[0]! as! Float - x), 0.01, "x is almost correct")
            XCTAssertLessThan(abs(osc[ii + 1].arguments[0]! as! Float - y), 0.01, "y is almost correct")
            XCTAssertEqual(osc[ii + 2].arguments[0]! as! Float, Float(t._radius), "radius is correct")
            XCTAssertEqual(osc[ii + 3].arguments[0]! as! Float, Float(t._force), "force is correct")
        }

        // Remove touches[1]
        TouchService.shared.removeTouches([touches[1]])

        osc = TouchService.shared.toOSC()
        XCTAssertEqual(osc.count, 4, "touches[1] is removed")
        ({
            XCTAssert(osc[0].address.string.contains("/touch01"), "osc[0] is x position")
            XCTAssert(osc[1].address.string.contains("/touch02"), "osc[1] is y position")
            XCTAssert(osc[2].address.string.contains("/touchradius0"), "osc[2] is radius")
            XCTAssert(osc[3].address.string.contains("/touchforce0"), "osc[3] is force")

            let x = Float(touches[0]._x) / Float(tWidth) * 2 - 1
            let y = Float(touches[0]._y) / Float(tHeight) * 2 - 1
            XCTAssertLessThan(abs(osc[0].arguments[0]! as! Float - x), 0.01, "x is almost correct")
            XCTAssertLessThan(abs(osc[1].arguments[0]! as! Float - y), 0.01, "y is almost correct")
            XCTAssertEqual(osc[2].arguments[0]! as! Float, Float(touches[0]._radius), "radius is correct")
            XCTAssertEqual(osc[3].arguments[0]! as! Float, Float(touches[0]._force), "force is correct")
        })()

        // Remove all touches
        TouchService.shared.removeAllTouches()
        osc = TouchService.shared.toOSC()
        XCTAssertEqual(osc.count, 0, "No messages returned afeter removeAllTouches")

        TouchService.shared.addTouches(touches) // add touches again
        TouchService.shared.disable()
        osc = TouchService.shared.toOSC()
        XCTAssertEqual(osc.count, 0, "TouchService resets touches when disabled")
    }

    func test_toJSON_empty() {
        AppSettingModel.shared.isActiveByCommand[.touch] = false
        let json = try! TouchService.shared.toJSON()
        XCTAssertEqual(json, JSON([:]), "Empty JSON")
    }

    func test_toJSON_notouch() {
        AppSettingModel.shared.isActiveByCommand[.touch] = true
        let json = try! TouchService.shared.toJSON()
        XCTAssertEqual(json, JSON(["touches": []]), "touches is an empty array")
    }

    func test_toJSON() {
        AppSettingModel.shared.isActiveByCommand[.touch] = true
        TouchService.shared.enable()

        let tWidth = 100
        let tHeight = 100
        TouchService.shared.setTouchArea(rect: CGRect(x: 0, y: 0, width: tWidth, height: tHeight))

        var touches: [UITouchMock] = [
            UITouchMock(12, 34, 0.1, 0.2),
            UITouchMock(56, 78, 0.3, 0.4),
        ]
        TouchService.shared.addTouches(touches)

        var json = try! TouchService.shared.toJSON()
        XCTAssertEqual(json["touches"].array!.count, 2, "2 touches returned")

        for (i, t) in json["touches"].array!.enumerated() {
            let x = Float(touches[i]._x) / Float(tWidth) * 2 - 1
            let y = Float(touches[i]._y) / Float(tHeight) * 2 - 1
            XCTAssertLessThan(abs(t["x"].float! - x), 0.01, "x is almost correct")
            XCTAssertLessThan(abs(t["y"].float! - y), 0.01, "y is almost correct")
            XCTAssertEqual(t["radius"].float!, Float(touches[i]._radius), "radius is correct")
            XCTAssertEqual(t["force"].float!, Float(touches[i]._force), "force is correct")
        }

        // Test updateTouches
        touches[0].update(23, 45, 0.5, 0.6)
        touches[1].update(67, 89, 0.7, 0.8)
        TouchService.shared.updateTouches(touches)

        json = try! TouchService.shared.toJSON()
        XCTAssertEqual(json["touches"].array!.count, 2, "2 touches returned")

        for (i, t) in json["touches"].array!.enumerated() {
            let x = Float(touches[i]._x) / Float(tWidth) * 2 - 1
            let y = Float(touches[i]._y) / Float(tHeight) * 2 - 1
            XCTAssertLessThan(abs(t["x"].float! - x), 0.01, "x is almost correct")
            XCTAssertLessThan(abs(t["y"].float! - y), 0.01, "y is almost correct")
            XCTAssertEqual(t["radius"].float!, Float(touches[i]._radius), "radius is correct")
            XCTAssertEqual(t["force"].float!, Float(touches[i]._force), "force is correct")
        }

        // Remove touches[1]
        TouchService.shared.removeTouches([touches[1]])

        json = try! TouchService.shared.toJSON()
        XCTAssertEqual(json["touches"].array!.count, 1, "touches[1] is removed")
        ({
            let t = json["touches"][0]
            let x = Float(touches[0]._x) / Float(tWidth) * 2 - 1
            let y = Float(touches[0]._y) / Float(tHeight) * 2 - 1 //
            XCTAssertLessThan(abs(t["x"].float! - x), 0.01, "x is almost correct")
            XCTAssertLessThan(abs(t["y"].float! - y), 0.01, "y is almost correct")
            XCTAssertEqual(t["radius"].float!, Float(touches[0]._radius), "radius is correct")
            XCTAssertEqual(t["force"].float!, Float(touches[0]._force), "force is correct")
        })()

        // Remove all touches
        TouchService.shared.removeAllTouches()
        json = try! TouchService.shared.toJSON()
        XCTAssertEqual(json["touches"].array!.count, 0, "No touches returned afeter removeAllTouches")

        TouchService.shared.addTouches(touches) // add touches again
        TouchService.shared.disable()
        json = try! TouchService.shared.toJSON()
        XCTAssertEqual(json["touches"].array!.count, 0, "TouchService resets touches when disabled")
    }

    func test_toLog_empty() {
        AppSettingModel.shared.isActiveByCommand[.touch] = false
        let log = TouchService.shared.toLog()
        XCTAssertEqual(log, [], "Empty log")
    }

    func test_toLog_notouch() {
        AppSettingModel.shared.isActiveByCommand[.touch] = true
        let log = TouchService.shared.toLog()
        XCTAssertEqual(log, [], "Empty log")
    }

    func test_toLog() {
        AppSettingModel.shared.isActiveByCommand[.touch] = true
        TouchService.shared.enable()

        let tWidth = 100
        let tHeight = 100
        TouchService.shared.setTouchArea(rect: CGRect(x: 0, y: 0, width: tWidth, height: tHeight))

        var touches: [UITouchMock] = [
            UITouchMock(12, 34, 0.1, 0.2),
            UITouchMock(56, 78, 0.3, 0.4),
        ]
        TouchService.shared.addTouches(touches)

        var log = TouchService.shared.toLog()
        XCTAssertEqual(log.count, 8, "TouchService returns 4 logs per touch")

        for (i, t) in touches.enumerated() {
            let ii = i * 4
            let x = Float(t._x) / Float(tWidth) * 2 - 1
            let y = Float(t._y) / Float(tHeight) * 2 - 1

            XCTAssertEqual(log[ii + 0], String(format: "touch:x:%.3f", x), "log[\(ii + 0)] is x position")
            XCTAssertEqual(log[ii + 1], String(format: "touch:y:%.3f", y), "log[\(ii + 1)] is y position")
            XCTAssertEqual(log[ii + 2], String(format: "touch:radius:%.3f", t._radius), "log[\(ii + 2)] is radius")
            XCTAssertEqual(log[ii + 3], String(format: "touch:force:%.3f", t._force), "log[\(ii + 3)] is force")
        }

        // Test updateTouches
        touches[0].update(23, 45, 0.5, 0.6)
        touches[1].update(67, 89, 0.7, 0.8)
        TouchService.shared.updateTouches(touches)

        log = TouchService.shared.toLog()
        XCTAssertEqual(log.count, 8, "TouchService returns 4 messages per touch")

        for (i, t) in touches.enumerated() {
            let ii = i * 4
            let x = Float(t._x) / Float(tWidth) * 2 - 1
            let y = Float(t._y) / Float(tHeight) * 2 - 1

            XCTAssertEqual(log[ii + 0], String(format: "touch:x:%.3f", x), "log[\(ii + 0)] is x position")
            XCTAssertEqual(log[ii + 1], String(format: "touch:y:%.3f", y), "log[\(ii + 1)] is y position")
            XCTAssertEqual(log[ii + 2], String(format: "touch:radius:%.3f", t._radius), "log[\(ii + 2)] is radius")
            XCTAssertEqual(log[ii + 3], String(format: "touch:force:%.3f", t._force), "log[\(ii + 3)] is force")
        }

        // Remove touches[1]
        TouchService.shared.removeTouches([touches[1]])

        log = TouchService.shared.toLog()
        XCTAssertEqual(log.count, 4, "touches[1] is removed")
        ({
            let t = touches[0]
            let x = Float(t._x) / Float(tWidth) * 2 - 1
            let y = Float(t._y) / Float(tHeight) * 2 - 1

            XCTAssertEqual(log[0], String(format: "touch:x:%.3f", x), "log[0] is x position")
            XCTAssertEqual(log[1], String(format: "touch:y:%.3f", y), "log[1] is y position")
            XCTAssertEqual(log[2], String(format: "touch:radius:%.3f", t._radius), "log[2] is radius")
            XCTAssertEqual(log[3], String(format: "touch:force:%.3f", t._force), "log[3] is force")
        })()

        // Remove all touches
        TouchService.shared.removeAllTouches()
        log = TouchService.shared.toLog()
        XCTAssertEqual(log.count, 0, "No messages returned afeter removeAllTouches")

        TouchService.shared.addTouches(touches) // add touches again
        TouchService.shared.disable()
        log = TouchService.shared.toLog()
        XCTAssertEqual(log.count, 0, "TouchService resets touches when disabled")
    }
}
