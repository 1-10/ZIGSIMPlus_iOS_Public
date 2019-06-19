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

/// Selector is used for settings with UISegmentedController
public struct Selector: DetailSetting {
    var key: DetailSettingsKey
    var label: String
    var segments: [String]
    var width: Int  // width of UISegmentController
    var value: Int
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

    /// Detail settings for commands.
    public func getCommandDetailSettings() -> [Command: [DetailSetting]] {
        return [
            .ndi: [
                Selector(key: .ndiType, label: "IMAGE TYPE", segments: ["CAMERA", "DEPTH"], width: 240, value: AppSettingModel.shared.ndiType.rawValue),
                Selector(key: .ndiCamera, label: "CAMERA", segments: ["REAR", "FRONT"], width: 240, value: AppSettingModel.shared.ndiCameraPosition.rawValue),
                Selector(key: .ndiDepthType, label: "DEPTH TYPE", segments: ["DEPTH", "DISPARITY"], width: 240, value: AppSettingModel.shared.depthType.rawValue),
            ],
            .compass: [
                Selector(key: .compassOrientation, label: "ORIENTATION", segments: ["PORTRAIT", "FACEUP"], width: 240, value: AppSettingModel.shared.compassOrientation.rawValue),
            ],
            .arkit: [
                Selector(key: .arkitTrackingType, label: "TRACKING TYPE", segments: ["DEVICE", "FACE", "MARKER"], width: 240, value: AppSettingModel.shared.arkitTrackingType.rawValue),
            ],
        ]
    }

    public func updateSetting(setting: DetailSetting) {
        switch setting {
        case let data as Selector:
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
