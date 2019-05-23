//
//  StringExtensionTests.swift
//  ZIGSIMPlusTests
//
//  Created by Nozomu Kuwae on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import XCTest
@testable import ZIGSIMPlus

class StringExtensionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAppendLines_WhenSelfIsEmpty() {
        var s1 = ""
        let s2 = "a"
        s1.appendLines(s2)
        XCTAssertEqual(s1, s2)
    }
    
    func testAppendLines_WhenSelfIsNotEmptyAndEndsWithLineBreak() {
        var s1 = "a\n"
        let s2 = "b"
        s1.appendLines(s2)
        XCTAssertEqual(s1, "a\nb")
    }

    func testAppendLines_WhenSelfIsNotEmptyAndNotEndsWithLineBreak() {
        var s1 = "a"
        let s2 = "b"
        s1.appendLines(s2)
        XCTAssertEqual(s1, "a\nb")
    }
}
