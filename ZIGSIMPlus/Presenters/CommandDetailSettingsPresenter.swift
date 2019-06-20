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
    case compassOrientation = 3
    case arkitTrackingType = 4
    case imageDetectorType = 5
    case imageDetectorAccuracy = 6
    case imageDetectorTracks = 7
    case imageDetectorNumberOfAnglesForSegment = 8
    case imageDetectorDetectsEyeBlink = 9
    case imageDetectorDetectsSmile = 10
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
            ],
            .compass: [
                SegmentedInt(.compassOrientation, "ORIENTATION", ["PORTRAIT", "FACEUP"], 240, app.compassOrientation.rawValue),
            ],
            .arkit: [
                SegmentedInt(.arkitTrackingType, "TRACKING TYPE", ["DEVICE", "FACE", "MARKER"], 240, app.arkitTrackingType.rawValue),
            ],
            .imageDetection: [
                SegmentedInt(.imageDetectorType, "DETECTION TYPE", ["FACE", "QR CODE", "RECTANGULE", "TEXT"], 240, app.imageDetectorType.rawValue),
                SegmentedInt(.imageDetectorAccuracy, "ACCURACY", ["LOW", "HIGH"], 240, app.imageDetectorAccuracy.rawValue),
                SegmentedBool(.imageDetectorTracks, "TRACKING", ["ON", "OFF"], 240, app.imageDetectorTracks),
                SegmentedInt(.imageDetectorNumberOfAnglesForSegment, "NUMBER OF FACE ANGLES", ["1", "3", "5", "7", "9", "11"], 240, app.imageDetectorNumberOfAnglesForSegment.rawValue),
                SegmentedBool(.imageDetectorDetectsEyeBlink, "DETECT EYE BLINK", ["ON", "OFF"], 240, app.imageDetectorDetectsEyeBlink),
                SegmentedBool(.imageDetectorDetectsSmile, "DETECT SMILE", ["ON", "OFF"], 240, app.imageDetectorDetectsSmile),
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
        default:
            break
        }
    }
}
