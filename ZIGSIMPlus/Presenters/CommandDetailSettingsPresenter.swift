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
    case ndiAudioEnabled = 4
    case ndiAudioBufferSize = 5
    case compassOrientation = 6
    case arkitTrackingType = 7
    case imageDetectorType = 8
    case imageDetectorAccuracy = 9
    case imageDetectorTracks = 10
    case imageDetectorNumberOfAnglesForSegment = 11
    case imageDetectorDetectsEyeBlink = 12
    case imageDetectorDetectsSmile = 13
    case beaconUUID = 14
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
                SegmentedInt(.ndiType, "IMAGE TYPE", ["CAMERA", "DEPTH"], 240, app.ndiType.rawValue),
                SegmentedInt(.ndiCamera, "CAMERA", ["REAR", "FRONT"], 240, app.ndiCameraPosition.rawValue),
                SegmentedInt(.ndiDepthType, "DEPTH TYPE", ["DEPTH", "DISPARITY"], 240, app.depthType.rawValue),
                SegmentedInt(.ndiResolution, "RESOLUTION", ["VGA", "HD", "FHD"], 240, app.ndiResolution.rawValue),
                SegmentedInt(.ndiAudioEnabled, "AUDIO", ["ON", "OFF"], 240, app.ndiAudioEnabled.rawValue),
                SegmentedInt(.ndiAudioBufferSize, "AUDIO LATENCY", ["LOW", "MID", "HIGH"], 240, app.ndiAudioBufferSize.rawValue),
            ],
            .compass: [
                SegmentedInt(.compassOrientation, "ORIENTATION", ["PORTRAIT", "FACEUP"], 240, app.compassOrientation.rawValue),
            ],
            .arkit: [
                SegmentedInt(.arkitTrackingType, "TRACKING TYPE", ["DEVICE", "FACE", "MARKER"], 240, app.arkitTrackingType.rawValue),
            ],
            .imageDetection: [
                SegmentedInt(.imageDetectorType, "DETECTION TYPE", ["FACE", "QR", "RECT", "TEXT"], 240, app.imageDetectorType.rawValue),
                SegmentedInt(.imageDetectorAccuracy, "ACCURACY", ["LOW", "HIGH"], 240, app.imageDetectorAccuracy.rawValue),
                SegmentedBool(.imageDetectorTracks, "TRACKING", ["ON", "OFF"], 240, app.imageDetectorTracks),
                SegmentedInt(.imageDetectorNumberOfAnglesForSegment, "NUMBER OF FACE ANGLES", ["1", "3", "5", "7", "9", "11"], 240, app.imageDetectorNumberOfAnglesForSegment.rawValue),
                SegmentedBool(.imageDetectorDetectsEyeBlink, "DETECT EYE BLINK", ["ON", "OFF"], 240, app.imageDetectorDetectsEyeBlink),
                SegmentedBool(.imageDetectorDetectsSmile, "DETECT SMILE", ["ON", "OFF"], 240, app.imageDetectorDetectsSmile),
            ],
            .beacon: [
                UUIDInput(.beaconUUID, "BEACON UUID", 270, app.beaconUUID),
            ],
        ]
    }

    public func updateSetting(setting: DetailSetting) {
        switch setting {
        case let data as SegmentedInt:
            switch data.key {
            case .ndiType:
                let val = NdiType(rawValue: data.value)!
                AppSettingModel.shared.ndiType = val
                Defaults[.userNdiType] = val
            case .ndiCamera:
                let val = NdiCameraPosition(rawValue: data.value)!
                AppSettingModel.shared.ndiCameraPosition = val
                Defaults[.userNdiCameraType] = val
            case .ndiDepthType:
                let val = DepthType(rawValue: data.value)!
                AppSettingModel.shared.depthType = val
                Defaults[.userDepthType] = val
            case .ndiResolution:
                let val = NdiResolution(rawValue: data.value)!
                AppSettingModel.shared.ndiResolution = val
                Defaults[.userNdiResolution] = val
            case .ndiAudioBufferSize:
                let val = NdiAudioBufferSize(rawValue: data.value)!
                AppSettingModel.shared.ndiAudioBufferSize = val
                Defaults[.userNdiAudioBufferSize] = val
            case .ndiAudioEnabled:
                let val = NdiAudioEnabled(rawValue: data.value)!
                AppSettingModel.shared.ndiAudioEnabled = val
                Defaults[.userNdiAudioEnabled] = val
            case .compassOrientation:
                let val = CompassOrientation(rawValue: data.value)!
                AppSettingModel.shared.compassOrientation = val
                Defaults[.userCompassOrientation] = val
            case .arkitTrackingType:
                let val = ArkitTrackingType(rawValue: data.value)!
                AppSettingModel.shared.arkitTrackingType = val
                Defaults[.userArkitTrackingType] = val
            case .imageDetectorType:
                let val = ImageDetectorType(rawValue: data.value)!
                AppSettingModel.shared.imageDetectorType = val
                Defaults[.userImageDetectorType] = val
            case .imageDetectorAccuracy:
                let val = ImageDetectorAccuracy(rawValue: data.value)!
                AppSettingModel.shared.imageDetectorAccuracy = val
                Defaults[.userImageDetectorAccuracy] = val
            case .imageDetectorNumberOfAnglesForSegment:
                let val = ImageDetectorNumberOfAnglesForSegment(rawValue: data.value)!
                AppSettingModel.shared.imageDetectorNumberOfAnglesForSegment = val
                Defaults[.userImageDetectorNumberOfAnglesForSegment] = val
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
