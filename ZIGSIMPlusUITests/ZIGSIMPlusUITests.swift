//
//  ZIGSIMPlusUITests.swift
//  ZIGSIMPlusUITests
//
//  Created by Nozomu Kuwae on 5/3/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import XCTest
@testable import ZIGSIMPlus

class ZIGSIMPlusUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_setting_tab() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let xcui = XCUIApplication()
        
        // "boundBy == 0" is Sensor tab, "boundBy == 1" is Start tab, "boundBy == 2" is Setting tab
        let settingTabBar = xcui.tabBars.buttons.element(boundBy: 2)
        settingTabBar.tap()
        test_textFiled(xcui,textFiledName: "ipAddressTextField",defaultValue: "172.17.1.20")
        test_textFiled(xcui,textFiledName: "portNumberTextField",defaultValue: "3333" )
        test_textFiled(xcui,textFiledName: "deviceUuidTextField",defaultValue: "abcdefg1234567-_" )
    }
    
    // If input value for textfields is valid, xcui.keyboards.count == 0.
    func test_textFiled(_ xcui: XCUIApplication, textFiledName: String, defaultValue: String) {
        let textFildsName = xcui.textFields[textFiledName]
        let originalValue = textFildsName.value as? String
        textFildsName.tap()
        deleteTextFiled(textFildsName)
        touchScrollView(xcui)
        XCTAssertEqual(xcui.keyboards.count, 1, "invalid value(no text)")
        
        textFildsName.tap()
        textFildsName.typeText(originalValue ?? defaultValue)
        touchScrollView(xcui)
        XCTAssertEqual(xcui.keyboards.count, 0, "valid value")
        
        textFildsName.tap()
        textFildsName.typeText("あ")
        touchScrollView(xcui)
        XCTAssertEqual(xcui.keyboards.count, 1, "invalid value")
        
        textFildsName.tap()
        textFildsName.typeText(XCUIKeyboardKey.delete.rawValue)
        touchScrollView(xcui)
        XCTAssertEqual(xcui.keyboards.count, 0, "valid value")
    }
    
    func deleteTextFiled(_ text:XCUIElement) {
        (text.value as! String).forEach {_ in
            text.typeText(XCUIKeyboardKey.delete.rawValue)
        }
    }
    
    func touchScrollView(_ xcui: XCUIApplication) {
        let app = XCUIApplication()
        let webView = app.scrollViews.element(boundBy: 0)
        let coordinate = webView.coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 0.3)) // Tap point is around upper right.
        coordinate.tap()
    }

}
