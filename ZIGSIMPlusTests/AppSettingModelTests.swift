//
//  AppSettingModelTests.swift
//  ZIGSIMPlusTests
//
//  Created by Nozomu Kuwae on 2019/06/14.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import XCTest
@testable import ZIGSIMPlus

class AppSettingModelTests: XCTestCase {
    override func setUp() {
    }

    override func tearDown() {
    }

    func testIsCameraUsed_WithoutParameter_WhenAllCameraCommandsInactive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = false
        AppSettingModel.shared.isActiveByCommand[.ndi] = false
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = false
        XCTAssertFalse(AppSettingModel.shared.isCameraUsed())
    }
    
    func testIsCameraUsed_WithoutParameter_WhenArkitActive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = true
        AppSettingModel.shared.isActiveByCommand[.ndi] = false
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = false
        XCTAssertTrue(AppSettingModel.shared.isCameraUsed())
    }

    func testIsCameraUsed_ExceptArkit_WhenAllCameraCommandsInactive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = false
        AppSettingModel.shared.isActiveByCommand[.ndi] = false
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = false
        XCTAssertFalse(AppSettingModel.shared.isCameraUsed(exceptBy: .arkit))
    }

    func testIsCameraUsed_ExceptArkit_WhenNdiActive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = false
        AppSettingModel.shared.isActiveByCommand[.ndi] = true
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = false
        XCTAssertTrue(AppSettingModel.shared.isCameraUsed(exceptBy: .arkit))
    }
 
    func testIsCameraUsed_ExceptNdi_WhenAllCameraCommandsInactive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = false
        AppSettingModel.shared.isActiveByCommand[.ndi] = false
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = false
        XCTAssertFalse(AppSettingModel.shared.isCameraUsed(exceptBy: .ndi))
    }
    
    func testIsCameraUsed_ExceptNdi_WhenImageDetectionActive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = false
        AppSettingModel.shared.isActiveByCommand[.ndi] = false
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = true
        XCTAssertTrue(AppSettingModel.shared.isCameraUsed(exceptBy: .ndi))
    }
    
    func testIsCameraUsed_ExceptImageDetection_WhenAllCameraCommandsInactive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = false
        AppSettingModel.shared.isActiveByCommand[.ndi] = false
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = false
        XCTAssertFalse(AppSettingModel.shared.isCameraUsed(exceptBy: .imageDetection))
    }
    
    func testIsCameraUsed_ExceptImageDetection_WhenArkitActive() {
        AppSettingModel.shared.isActiveByCommand[.arkit] = true
        AppSettingModel.shared.isActiveByCommand[.ndi] = false
        AppSettingModel.shared.isActiveByCommand[.imageDetection] = false
        XCTAssertTrue(AppSettingModel.shared.isCameraUsed(exceptBy: .imageDetection))
    }
}
