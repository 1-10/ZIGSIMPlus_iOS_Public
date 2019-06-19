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
}


/// DetailSetting data represents each setting in CommandDetailSettings view.
/// We only have Selector now, but you can support input types by adding a struct which implement DetailSetting.
protocol DetailSetting {}

/// Segmented is used for settings with UISegmentedController
public struct Segmented: DetailSetting {
    var key: DetailSettingsKey
    var label: String
    var segments: [String]
    var width: Int  // width of UISegmentController
    var value: Int

    init (_ key: DetailSettingsKey, _ label: String, _ segments: [String], _ width: Int, _ value: Int) {
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
                Segmented(.ndiType, "IMAGE TYPE", ["CAMERA", "DEPTH"], 240, app.ndiType.rawValue),
                Segmented(.ndiCamera, "CAMERA", ["REAR", "FRONT"], 240, app.ndiCameraPosition.rawValue),
                Segmented(.ndiDepthType, "DEPTH TYPE", ["DEPTH", "DISPARITY"], 240, app.depthType.rawValue),
            ],
            .compass: [
                Segmented(.compassOrientation, "ORIENTATION", ["PORTRAIT", "FACEUP"], 240, app.compassOrientation.rawValue),
            ],
            .arkit: [
                Segmented(.arkitTrackingType, "TRACKING TYPE", ["DEVICE", "FACE", "MARKER"], 240, app.arkitTrackingType.rawValue),
            ],
        ]
    }

    public func updateSetting(setting: DetailSetting) {
        switch setting {
        case let data as Segmented:
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
            }
        default:
            break
        }
    }
}
