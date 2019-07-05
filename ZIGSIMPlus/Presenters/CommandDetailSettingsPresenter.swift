//
//  CommandDetailSettingsPresenter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/18.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public enum DetailSettingsKey: Int {
    case ndiType = 0
    case ndiCamera = 1
    case ndiDepthType = 2
    case ndiResolution = 3
    case ndiAudioBufferSize = 4
    case compassOrientation = 5
    case arkitTrackingType = 6
    case imageDetectorType = 7
    case imageDetectorAccuracy = 8
    case imageDetectorTracks = 9
    case imageDetectorNumberOfAnglesForSegment = 10
    case imageDetectorDetectsEyeBlink = 11
    case imageDetectorDetectsSmile = 12
    case beaconUUID = 13
}


/// DetailSetting data represents each setting in CommandDetailSettings view.
/// We only have Segmented now, but you can support input types by adding a struct which implement DetailSetting.
protocol DetailSetting {}

protocol Segmented: DetailSetting {
    var key: DetailSettingsKey { get set }
    var label: String { get set }
    var segments: [String] { get set }
    var width: Int { get set }  // width of UISegmentController
}

/// Segmented is used for settings with UISegmentedController
public struct SegmentedInt: Segmented {
    var key: DetailSettingsKey
    var label: String
    var segments: [String]
    var width: Int
    var value: Int

    init (_ key: DetailSettingsKey, _ label: String, _ segments: [String], _ width: Int, _ value: Int) {
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
    
    init (_ key: DetailSettingsKey, _ label: String, _ segments: [String], _ width: Int, _ value: Bool) {
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

    init (_ key: DetailSettingsKey, _ label: String, _ width: Int, _ value: String) {
        self.key = key
        self.label = label
        self.width = width
        self.value = value
    }
}

protocol CommandDetailSettingsPresenterProtocol {
    func getCommandDetailSettings() -> [Command: [DetailSetting]]
    func updateSetting(setting: DetailSetting)
}

final class CommandDetailSettingsPresenter: CommandDetailSettingsPresenterProtocol {

    // Get data to generate detail settings view dinamically
    public func getCommandDetailSettings() -> [Command: [DetailSetting]] {
        let app = AppSettingModel.shared

        return [
            .ndi: [
                SegmentedInt(.ndiType, "Image Type", ["CAMERA", "DEPTH"], 240, app.ndiType.rawValue),
                SegmentedInt(.ndiCamera, "Camera", ["REAR", "FRONT"], 240, app.ndiCameraPosition.rawValue),
                SegmentedInt(.ndiDepthType, "Depth Type", ["DEPTH", "DISPARITY"], 240, app.depthType.rawValue),
                SegmentedInt(.ndiResolution, "Resolution", ["VGA", "HD", "FHD"], 240, app.ndiResolution.rawValue),
                SegmentedInt(.ndiAudioBufferSize, "Audio Latency", ["LOW", "MID", "HIGH"], 240, app.ndiAudioBufferSize.rawValue),
            ],
            .compass: [
                SegmentedInt(.compassOrientation, "Orientation", ["PORTRAIT", "FACEUP"], 240, app.compassOrientation.rawValue),
            ],
            .arkit: [
                SegmentedInt(.arkitTrackingType, "Tracking Type", ["DEVICE", "FACE", "MARKER"], 240, app.arkitTrackingType.rawValue),
            ],
            .imageDetection: [
                SegmentedInt(.imageDetectorType, "Detection Type", ["FACE", "QR", "RECT", "TEXT"], 240, app.imageDetectorType.rawValue),
                SegmentedInt(.imageDetectorAccuracy, "Accuracy", ["LOW", "HIGH"], 240, app.imageDetectorAccuracy.rawValue),
                SegmentedBool(.imageDetectorTracks, "Tracking", ["ON", "OFF"], 240, app.imageDetectorTracks),
                SegmentedInt(.imageDetectorNumberOfAnglesForSegment, "Number Of Face Angles", ["1", "3", "5", "7", "9", "11"], 240, app.imageDetectorNumberOfAnglesForSegment.rawValue),
                SegmentedBool(.imageDetectorDetectsEyeBlink, "Detect Eye Blink", ["ON", "OFF"], 240, app.imageDetectorDetectsEyeBlink),
                SegmentedBool(.imageDetectorDetectsSmile, "Detect Smile", ["ON", "OFF"], 240, app.imageDetectorDetectsSmile),
            ],
            .beacon: [
                UUIDInput(.beaconUUID, "Beacon UUID", 270, app.beaconUUID),
            ],
        ]
    }

    public func updateSetting(setting: DetailSetting) {
        switch setting {
        case let data as SegmentedInt:
            switch data.key {
            case .ndiType:
                AppSettingModel.shared.ndiType = NdiType(rawValue: data.value)!
                Defaults[.userNdiType] = data.value
            case .ndiCamera:
                AppSettingModel.shared.ndiCameraPosition = NdiCameraPosition(rawValue: data.value)!
                Defaults[.userNdiCameraType] = data.value
            case .ndiDepthType:
                AppSettingModel.shared.depthType = DepthType(rawValue: data.value)!
                Defaults[.userDepthType] = data.value
            case .ndiResolution:
                AppSettingModel.shared.ndiResolution = NdiResolution(rawValue: data.value)!
                Defaults[.userNdiResolution] = data.value
            case .ndiAudioBufferSize:
                AppSettingModel.shared.ndiAudioBufferSize = NdiAudioBufferSize(rawValue: data.value)!
                Defaults[.userNdiAudioBufferSize] = data.value
            case .compassOrientation:
                AppSettingModel.shared.compassOrientation = CompassOrientation(rawValue: data.value)!
                Defaults[.userCompassOrientation] = data.value
            case .arkitTrackingType:
                AppSettingModel.shared.arkitTrackingType = ArkitTrackingType(rawValue: data.value)!
                Defaults[.userArkitTrackingType] = data.value
            case .imageDetectorType:
                AppSettingModel.shared.imageDetectorType = ImageDetectorType(rawValue: data.value)!
                Defaults[.userImageDetectorType] = data.value
            case .imageDetectorAccuracy:
                AppSettingModel.shared.imageDetectorAccuracy = ImageDetectorAccuracy(rawValue: data.value)!
                Defaults[.userImageDetectorAccuracy] = data.value
            case .imageDetectorNumberOfAnglesForSegment:
                AppSettingModel.shared.imageDetectorNumberOfAnglesForSegment = ImageDetectorNumberOfAnglesForSegment(rawValue: data.value)!
                Defaults[.userImageDetectorNumberOfAnglesForSegment] = data.value
            default:
                fatalError("Undefined key")
            }
        case let data as SegmentedBool:
            switch data.key {
            case .imageDetectorTracks:
                AppSettingModel.shared.imageDetectorTracks = data.value
                Defaults[.userImageDetectorTracks] = data.value
            case .imageDetectorDetectsEyeBlink:
                AppSettingModel.shared.imageDetectorDetectsEyeBlink = data.value
                Defaults[.userImageDetectorDetectsEyeBlink] = data.value
            case .imageDetectorDetectsSmile:
                AppSettingModel.shared.imageDetectorDetectsSmile = data.value
                Defaults[.userImageDetectorDetectsSmile] = data.value
            default:
                fatalError("Undefined key")
            }
        case let data as UUIDInput:
            switch data.key {
            case .beaconUUID:
                AppSettingModel.shared.beaconUUID = data.value
                Defaults[.userBeaconUUID] = data.value
            default:
                fatalError("Undefined key")
            }
        default:
            break
        }
    }
}
