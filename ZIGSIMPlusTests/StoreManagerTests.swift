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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_getJSON() {
        let json = StoreManager.shared.getJSON()
        let device = json["device"] as! [String:AnyObject]

        XCTAssertEqual(device["name"] as? String, "iPhone X")
        XCTAssertEqual(device["uuid"] as? String, AppSettingModel.shared.deviceUUID)
        XCTAssertEqual(device["os"] as? String, "ios")
        XCTAssertEqual(device["osversion"] as? String, "12.2")
        XCTAssertEqual(device["displaywidth"] as? Int, 1125)
        XCTAssertEqual(device["displayheight"] as? Int, 2436)
    }
}
