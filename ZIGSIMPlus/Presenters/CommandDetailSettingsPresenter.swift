//
//  CommandDetailSettingsPresenter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/18.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public enum DetailSettingsKey: Int {
    case ndiSceneType
    case ndiWorldType
    case ndiCamera
    case ndiDepthType
    case ndiHumanType
    case ndiResolution
    case ndiAudioEnabled
    case ndiAudioBufferSize
    case compassOrientation
    case arkitTrackingType
    case arkitFeaturePointsEnabled
    case imageDetectorType
    case imageDetectorCameraPosition
    case imageDetectorResolution
    case imageDetectorAccuracy
    case imageDetectorTracks
    case imageDetectorNumberOfAngles
    case imageDetectorDetectsEyeBlink
    case imageDetectorDetectsSmile
    case beaconUUID
}

/// DetailSetting data represents each setting in CommandDetailSettings view.
/// We only have Segmented now, but you can support input types by adding a struct which implement DetailSetting.
protocol DetailSetting {}

protocol Segmented: DetailSetting {
    var key: DetailSettingsKey { get set }
    var label: String { get set }
    var segments: [String] { get set }
    var width: Int { get set } // width of UISegmentController
}

/// Segmented is used for settings with UISegmentedController
public struct SegmentedInt: Segmented {
    var key: DetailSettingsKey
    var label: String
    var segments: [String]
    var width: Int
    var value: Int

    init(_ key: DetailSettingsKey, _ label: String, _ segments: [String], _ width: Int, _ value: Int) {
        self.key = key
        self.label = label
        self.segments = segments
        self.width = width
        self.value = value
    }
}

public struct SegmentedBool: Segmented {
    var key: DetailSettingsKey
    var label: String
    var segments: [String]
    var width: Int
    var value: Bool

    init(_ key: DetailSettingsKey, _ label: String, _ segments: [String], _ width: Int, _ value: Bool) {
        self.key = key
        self.label = label
        self.segments = segments
        self.width = width
        self.value = value
    }
}

// For example, If you want to support settings with Float slider, use this:
// public struct FloatInput: DetailSetting {
//     var key: DetailSettingsKey
//     var label: String
//     var width: Int
//     var value: Float
// }

public struct UUIDInput: DetailSetting {
    var key: DetailSettingsKey
    var label: String
    var width: Int
    var value: String

    init(_ key: DetailSettingsKey, _ label: String, _ width: Int, _ value: String) {
        self.key = key
        self.label = label
        self.width = width
        self.value = value
    }
}

protocol CommandDetailSettingsPresenterProtocol {
    func getCommandDetailSettings() -> [Command: [DetailSetting]]
    func updateSetting(setting: DetailSetting)
    func setNdiSceneType(ndiSceneType: NdiSceneType)
    func setNdiCameraPosition(cameraPosition: CameraPosition)
    func didSelectedAndInitSegment(settingKey: DetailSettingsKey)
    func setAvailabilityOfNdiSceneType()
}

protocol CommandDetailSettingsPresenterDelegate: AnyObject {
    func setSelectedSegmentIndex(index: Int)
    func setSelectedSegmentActivity(isEnabled: Bool)
    func getSegmentedIndexOf(tagNo: Int) -> Int?
    func setSegmentedIndexOf(tagNo: Int, index: Int)
    func setSegmentActivityOf(tagNo: Int, isEnable: Bool)
    func getCurrentSegmentId() -> Int
    func setUnavailableBodyTracking()
}

final class CommandDetailSettingsPresenter: CommandDetailSettingsPresenterProtocol {
    let videoCaptureService: VideoCaptureServiceProtocol
    let arkitService: ArkitServiceProtocol
    private weak var view: CommandDetailSettingsPresenterDelegate!

    init(view: CommandDetailSettingsPresenterDelegate,
         videoCaptureService: VideoCaptureServiceProtocol = VideoCaptureService.shared,
         arkitService: ArkitServiceProtocol = ArkitService.shared) {
        self.view = view
        self.videoCaptureService = videoCaptureService
        self.arkitService = arkitService
    }

    // Get data to generate detail settings view dinamically
    public func getCommandDetailSettings() -> [Command: [DetailSetting]] {
        let app = AppSettingModel.shared

        // swiftlint:disable line_length
        return [
            .ndi: [
                SegmentedInt(.ndiSceneType, "Scene Type", ["WORLD", "HUMAN"], 240, app.ndiSceneType.rawValue),
                SegmentedInt(.ndiWorldType, "World Image Type", ["CAMERA", "DEPTH", "BOTH"], 240, app.ndiWorldType.rawValue),
                SegmentedInt(.ndiCamera, "Camera", ["REAR", "FRONT"], 240, app.ndiCameraPosition.rawValue),
                SegmentedInt(.ndiDepthType, "Depth Type", ["DEPTH", "DISPARITY"], 240, app.depthType.rawValue),
                SegmentedInt(.ndiHumanType, "Human Image Type", ["HUMAN", "BOTH1", "BOTH2"], 240, app.ndiHumanType.rawValue),
                SegmentedInt(.ndiResolution, "Resolution", ["VGA", "HD", "FHD"], 240, app.ndiResolution.rawValue),
                SegmentedInt(.ndiAudioEnabled, "Audio", ["ON", "OFF"], 240, app.ndiAudioEnabled.rawValue),
                SegmentedInt(.ndiAudioBufferSize, "Audio Latency", ["LOW", "MID", "HIGH"], 240, app.ndiAudioBufferSize.rawValue),
            ],
            .compass: [
                SegmentedInt(.compassOrientation, "Orientation", ["PORTRAIT", "FACEUP"], 240, app.compassOrientation.rawValue),
            ],
            .arkit: [
                SegmentedInt(.arkitTrackingType, "Tracking Type", ["DEVICE", "FACE", "MARKER", "BODY"], 260, app.arkitTrackingType.rawValue),
                SegmentedInt(.arkitFeaturePointsEnabled, "Feature Points", ["ON", "OFF"], 240, app.arkitFeaturePointsEnabled.rawValue),
            ],
            .imageDetection: [
                SegmentedInt(.imageDetectorType, "Detection Type", ["FACE", "QR", "RECT", "TEXT"], 240, app.imageDetectorType.rawValue),
                SegmentedInt(.imageDetectorCameraPosition, "Camera", ["REAR", "FRONT"], 240, app.imageDetectorCameraPosition.rawValue),
                SegmentedInt(.imageDetectorResolution, "Resolution", ["VGA", "HD", "FHD"], 240, app.imageDetectorResolution.rawValue),
                SegmentedInt(.imageDetectorAccuracy, "Accuracy", ["LOW", "HIGH"], 240, app.imageDetectorAccuracy.rawValue),
                SegmentedBool(.imageDetectorTracks, "Tracking", ["ON", "OFF"], 240, app.imageDetectorTracks),
                SegmentedInt(.imageDetectorNumberOfAngles, "Number of Face Angles", ["1", "3", "5", "7", "9", "11"], 240, app.imageDetectorNumberOfAngles.rawValue),
                SegmentedBool(.imageDetectorDetectsEyeBlink, "Detect Eye Blink", ["ON", "OFF"], 240, app.imageDetectorDetectsEyeBlink),
                SegmentedBool(.imageDetectorDetectsSmile, "Detect Smile", ["ON", "OFF"], 240, app.imageDetectorDetectsSmile),
            ],
            .beacon: [
                UUIDInput(.beaconUUID, "Beacon UUID", 270, app.beaconUUID),
            ],
        ]
        // swiftlint:enable line_length
    }

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    public func updateSetting(setting: DetailSetting) {
        switch setting {
        case let data as SegmentedInt:
            switch data.key {
            case .ndiSceneType:
                AppSettingModel.shared.ndiSceneType = NdiSceneType(rawValue: data.value)!
            case .ndiWorldType:
                AppSettingModel.shared.ndiWorldType = NdiWorldType(rawValue: data.value)!
            case .ndiCamera:
                AppSettingModel.shared.ndiCameraPosition = CameraPosition(rawValue: data.value)!
            case .ndiDepthType:
                AppSettingModel.shared.depthType = DepthType(rawValue: data.value)!
            case .ndiHumanType:
                AppSettingModel.shared.ndiHumanType = NdiHumanType(rawValue: data.value)!
            case .ndiResolution:
                AppSettingModel.shared.ndiResolution = VideoResolution(rawValue: data.value)!
            case .ndiAudioBufferSize:
                AppSettingModel.shared.ndiAudioBufferSize = NdiAudioBufferSize(rawValue: data.value)!
            case .ndiAudioEnabled:
                AppSettingModel.shared.ndiAudioEnabled = NdiAudioEnabled(rawValue: data.value)!
            case .compassOrientation:
                AppSettingModel.shared.compassOrientation = CompassOrientation(rawValue: data.value)!
            case .arkitTrackingType:
                AppSettingModel.shared.arkitTrackingType = ArkitTrackingType(rawValue: data.value)!
            case .arkitFeaturePointsEnabled:
                AppSettingModel.shared.arkitFeaturePointsEnabled = ArkitFeaturePointsEnabled(rawValue: data.value)!
            case .imageDetectorType:
                AppSettingModel.shared.imageDetectorType = ImageDetectorType(rawValue: data.value)!
            case .imageDetectorCameraPosition:
                AppSettingModel.shared.imageDetectorCameraPosition = CameraPosition(rawValue: data.value)!
            case .imageDetectorResolution:
                AppSettingModel.shared.imageDetectorResolution = VideoResolution(rawValue: data.value)!
            case .imageDetectorAccuracy:
                AppSettingModel.shared.imageDetectorAccuracy = ImageDetectorAccuracy(rawValue: data.value)!
            case .imageDetectorNumberOfAngles:
                AppSettingModel.shared.imageDetectorNumberOfAngles = ImageDetectorNumberOfAngles(rawValue: data.value)!
            default:
                fatalError("Undefined key")
            }
        case let data as SegmentedBool:
            switch data.key {
            case .imageDetectorTracks:
                AppSettingModel.shared.imageDetectorTracks = data.value
            case .imageDetectorDetectsEyeBlink:
                AppSettingModel.shared.imageDetectorDetectsEyeBlink = data.value
            case .imageDetectorDetectsSmile:
                AppSettingModel.shared.imageDetectorDetectsSmile = data.value
            default:
                fatalError("Undefined key")
            }
        case let data as UUIDInput:
            switch data.key {
            case .beaconUUID:
                AppSettingModel.shared.beaconUUID = data.value
            default:
                fatalError("Undefined key")
            }
        default:
            break
        }
    }

    public func didSelectedAndInitSegment(settingKey: DetailSettingsKey) {
        switch settingKey {
        case .ndiWorldType:
            if !isDepthRearCameraAvailable() {
                view.setSelectedSegmentIndex(index: 0)
                view.setSelectedSegmentActivity(isEnabled: false)
            }

            if !isDepthFrontCameraAvailable(), view.getCurrentSegmentId() == 1 || view.getCurrentSegmentId() == 2 {
                setNdiCameraPosition(cameraPosition: .BACK)
                view.setSegmentedIndexOf(tagNo: DetailSettingsKey.ndiCamera.rawValue, index: 0)
                view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiCamera.rawValue, isEnable: false)
            } else {
                view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiCamera.rawValue, isEnable: true)
            }

        case .ndiCamera:
            if !isDepthFrontCameraAvailable() {
                setDepthFrontCameraAvailability()
            }
        case .ndiDepthType:
            if !isDepthRearCameraAvailable() {
                view.setSelectedSegmentActivity(isEnabled: false)
            }
        case .arkitTrackingType:
            if !isBodyTrackingAvailable() {
                view.setUnavailableBodyTracking()
            }
        default:
            return
        }
    }

    public func setAvailabilityOfNdiSceneType() {
        if !isHumanSegmentationAvailable() {
            setNdiSceneType(ndiSceneType: .WORLD)
            view.setSegmentedIndexOf(tagNo: DetailSettingsKey.ndiSceneType.rawValue, index: 0)
            view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiSceneType.rawValue, isEnable: false)
            view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiHumanType.rawValue, isEnable: false)
        } else {
            view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiWorldType.rawValue, isEnable: true)
            view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiCamera.rawValue, isEnable: true)
            view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiDepthType.rawValue, isEnable: true)
            view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiHumanType.rawValue, isEnable: true)

            let segmentedForNdiSceneTypeIndex = view.getSegmentedIndexOf(tagNo: DetailSettingsKey.ndiSceneType.rawValue)
            if segmentedForNdiSceneTypeIndex == NdiSceneType.WORLD.rawValue {
                didSelectedAndInitSegment(settingKey: DetailSettingsKey.ndiWorldType)
                didSelectedAndInitSegment(settingKey: DetailSettingsKey.ndiCamera)
                didSelectedAndInitSegment(settingKey: DetailSettingsKey.ndiDepthType)
                view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiHumanType.rawValue, isEnable: false)
            } else if segmentedForNdiSceneTypeIndex == NdiSceneType.HUMAN.rawValue {
                view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiWorldType.rawValue, isEnable: false)
                view.setSegmentActivityOf(tagNo: DetailSettingsKey.ndiDepthType.rawValue, isEnable: false)
            }
        }
    }

    internal func setNdiCameraPosition(cameraPosition: CameraPosition) {
        AppSettingModel.shared.ndiCameraPosition = cameraPosition
    }

    internal func setNdiSceneType(ndiSceneType: NdiSceneType) {
        AppSettingModel.shared.ndiSceneType = ndiSceneType
    }

    private func isBodyTrackingAvailable() -> Bool { arkitService.isBodyTrackingAvailable() }

    private func isDepthRearCameraAvailable() -> Bool { videoCaptureService.isDepthRearCameraAvailable() }

    private func isDepthFrontCameraAvailable() -> Bool { videoCaptureService.isDepthFrontCameraAvailable() }

    private func isHumanSegmentationAvailable() -> Bool { videoCaptureService.isHumanSegmentationAvailable() }

    private func setDepthFrontCameraAvailability() {
        if view.getSegmentedIndexOf(tagNo: DetailSettingsKey.ndiWorldType.rawValue) == 1 {
            setNdiCameraPosition(cameraPosition: .BACK)
            view.setSelectedSegmentIndex(index: 0)
            view.setSelectedSegmentActivity(isEnabled: false)
        } else {
            view.setSelectedSegmentActivity(isEnabled: true)
        }
    }
}
