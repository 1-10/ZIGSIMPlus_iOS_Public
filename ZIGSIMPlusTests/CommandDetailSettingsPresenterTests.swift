//
//  CommandDetailSettingsPresenterTests.swift
//  ZIGSIMPlusTests
//
//  Created by YoneyamaShunpei on 2021/07/27.
//  Copyright © 2021 1→10, Inc. All rights reserved.
//

import Foundation

import XCTest
@testable import ZIG_SIM_PRO

class CommandDetailSettingsPresenterTests: XCTestCase {
    var presenter: CommandDetailSettingsPresenter!
    let view = DummyCommandDetailSettingController()

    override func setUp() {}
    override func tearDown() {}

    private func initVideoCaptureServiceSegments(isDepthRearCamEnabled: Bool = false, isDepthFrontCamEnabled: Bool = false, isHumanEnabled: Bool = false) {
        let videoCaptureService = DummyVideoCaptureService(
            depthRearCameraAvailbility: isDepthRearCamEnabled,
            depthFrontCameraAvailbility: isDepthFrontCamEnabled,
            humanAvailbility: isHumanEnabled
        )
        presenter = CommandDetailSettingsPresenter(view: view, videoCaptureService: videoCaptureService)
        presenter.setAvailabilityOfNdiSceneType()
    }

    private func initArkitServiceSegments(isBodyEnabled: Bool) {
        let arkitService = DummyArkitService(
            bodyAvailbility: isBodyEnabled
        )
        presenter = CommandDetailSettingsPresenter(view: view, arkitService: arkitService)
        presenter.didSelectedAndInitSegment(settingKey: DetailSettingsKey.arkitTrackingType)
    }

    private func selectedSegment(key: DetailSettingsKey, index: Int) {
        view.setSelectedSegmentIndex(index: index)
        view.setSegmentedIndexOf(tagNo: key.rawValue, index: index)
        presenter.setAvailabilityOfNdiSceneType()
        presenter.didSelectedAndInitSegment(settingKey: key)
    }

    func test_frontDepthCamera_is_available() {
        initVideoCaptureServiceSegments(isDepthRearCamEnabled: true, isDepthFrontCamEnabled: true)
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiCamera.rawValue] {
            XCTAssertTrue(isEnabled)
        }
    }

    func test_frontDepthCamera_is_not_available() {
        initVideoCaptureServiceSegments(isDepthRearCamEnabled: true, isDepthFrontCamEnabled: false)
        selectedSegment(key: DetailSettingsKey.ndiWorldType, index: 1)
        if let index = view.specificationSegmentIndexes[DetailSettingsKey.ndiCamera.rawValue] {
            XCTAssertEqual(index, 0)
        }
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiCamera.rawValue] {
            XCTAssertFalse(isEnabled)
        }
    }

    func test_human_is_available() {
        initVideoCaptureServiceSegments(isDepthRearCamEnabled: true, isDepthFrontCamEnabled: true, isHumanEnabled: true)
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiSceneType.rawValue] {
            XCTAssertTrue(isEnabled)
        }

        selectedSegment(key: DetailSettingsKey.ndiSceneType, index: 0)
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiHumanType.rawValue] {
            XCTAssertFalse(isEnabled)
        }
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiCamera.rawValue] {
            XCTAssertTrue(isEnabled)
        }
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiDepthType.rawValue] {
            XCTAssertTrue(isEnabled)
        }

        selectedSegment(key: DetailSettingsKey.ndiSceneType, index: 1)
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiHumanType.rawValue] {
            XCTAssertTrue(isEnabled)
        }
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiCamera.rawValue] {
            XCTAssertTrue(isEnabled)
        }
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiDepthType.rawValue] {
            XCTAssertFalse(isEnabled)
        }
    }

    func test_human_is_not_available() {
        initVideoCaptureServiceSegments(isHumanEnabled: false)
        selectedSegment(key: DetailSettingsKey.ndiSceneType, index: 1)
        if let index = view.specificationSegmentIndexes[DetailSettingsKey.ndiSceneType.rawValue] {
            XCTAssertEqual(index, 0)
        }
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiSceneType.rawValue] {
            XCTAssertFalse(isEnabled)
        }
        if let isEnabled = view.isEnabledOfSpecificationSegments[DetailSettingsKey.ndiHumanType.rawValue] {
            XCTAssertFalse(isEnabled)
        }
    }

    func test_body_is_available() {
        initArkitServiceSegments(isBodyEnabled: true)
        XCTAssertEqual(view.arKitTypeSegmentNumber, 4)
    }

    func test_body_is_not_available() {
        initArkitServiceSegments(isBodyEnabled: false)
        XCTAssertEqual(view.arKitTypeSegmentNumber, 3)
    }
}

class DummyCommandDetailSettingController: CommandDetailSettingsPresenterDelegate {
    private var selectedSegmentIndex: Int = -1
    var specificationSegmentIndexes: [Int: Int] = [
        DetailSettingsKey.ndiSceneType.rawValue: 0,
        DetailSettingsKey.ndiWorldType.rawValue: 0,
        DetailSettingsKey.ndiCamera.rawValue: 0,
        DetailSettingsKey.ndiDepthType.rawValue: 0,
        DetailSettingsKey.ndiHumanType.rawValue: 0,
        DetailSettingsKey.arkitTrackingType.rawValue: 0,
    ]
    private var isEnabledOfSelectedSegment: Bool = false
    var isEnabledOfSpecificationSegments: [Int: Bool] = [
        DetailSettingsKey.ndiSceneType.rawValue: true,
        DetailSettingsKey.ndiWorldType.rawValue: true,
        DetailSettingsKey.ndiCamera.rawValue: true,
        DetailSettingsKey.ndiDepthType.rawValue: true,
        DetailSettingsKey.ndiHumanType.rawValue: true,
        DetailSettingsKey.arkitTrackingType.rawValue: true,
    ]
    var arKitTypeSegmentNumber: Int = 4

    func setSelectedSegmentIndex(index: Int) {
        selectedSegmentIndex = index
    }

    func setSelectedSegmentActivity(isEnabled: Bool) {
        isEnabledOfSelectedSegment = isEnabled
    }

    func getSegmentedIndexOf(tagNo: Int) -> Int? {
        return specificationSegmentIndexes[tagNo]
    }

    func setSegmentedIndexOf(tagNo: Int, index: Int) {
        specificationSegmentIndexes[tagNo] = index
    }

    func setSegmentActivityOf(tagNo: Int, isEnable: Bool) {
        isEnabledOfSpecificationSegments[tagNo] = isEnable
    }

    func getCurrentSegmentId() -> Int {
        return selectedSegmentIndex
    }

    func setUnavailableBodyTracking() {
        arKitTypeSegmentNumber = 3
    }
}

class DummyArkitService: ArkitServiceProtocol {
    var bodyAvailbility: Bool

    init(bodyAvailbility: Bool) {
        self.bodyAvailbility = bodyAvailbility
    }

    func isBodyTrackingAvailable() -> Bool {
        return bodyAvailbility
    }
}

class DummyVideoCaptureService: VideoCaptureServiceProtocol {
    var depthRearCameraAvailbility: Bool
    var depthFrontCameraAvailbility: Bool
    var humanAvailbility: Bool

    init(depthRearCameraAvailbility: Bool, depthFrontCameraAvailbility: Bool, humanAvailbility: Bool) {
        self.depthRearCameraAvailbility = depthRearCameraAvailbility
        self.depthFrontCameraAvailbility = depthFrontCameraAvailbility
        self.humanAvailbility = humanAvailbility
    }

    func isNDIAvailable() -> Bool {
        return true
    }

    func isImageDetectionAvailable() -> Bool {
        return true
    }

    func isDepthRearCameraAvailable() -> Bool {
        return depthRearCameraAvailbility
    }

    func isDepthFrontCameraAvailable() -> Bool {
        return depthFrontCameraAvailbility
    }

    func isHumanSegmentationAvailable() -> Bool {
        return humanAvailbility
    }
}
