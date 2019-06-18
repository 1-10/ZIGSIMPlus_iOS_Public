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

public struct DetailSettingsSegmented {
    var key: DetailSettingsKey
    var label: String
    var segments: [String]
    var width: Int
    var value: Int
}

public enum DetailSettingsData {
    case segmented(DetailSettingsSegmented)
}

protocol CommandDetailSettingsPresenterProtocol {
    func getCommandDetailSettings() -> [Command: [DetailSettingsData]]
    func updateSetting(setting: DetailSettingsData)
}

final class CommandDetailSettingsPresenter: CommandDetailSettingsPresenterProtocol {

    public func getCommandDetailSettings() -> [Command: [DetailSettingsData]] {
        return [
            .ndi: [
                .segmented(DetailSettingsSegmented(key: .ndiType, label: "IMAGE TYPE", segments: ["CAMERA", "DEPTH"], width: 240, value: AppSettingModel.shared.ndiType.rawValue)),
                .segmented(DetailSettingsSegmented(key: .ndiCamera, label: "CAMERA", segments: ["REAR", "FRONT"], width: 240, value: AppSettingModel.shared.ndiCameraPosition.rawValue)),
                .segmented(DetailSettingsSegmented(key: .ndiDepthType, label: "DEPTH TYPE", segments: ["DEPTH", "DISPARITY"], width: 240, value: AppSettingModel.shared.ndiCameraPosition.rawValue)),
            ],
            .compass: [
                .segmented(DetailSettingsSegmented(key: .compassOrientation, label: "ORIENTATION", segments: ["PORTRAIT", "FACEUP"], width: 240, value: AppSettingModel.shared.compassOrientation.rawValue)),
            ],
            .arkit: [
                .segmented(DetailSettingsSegmented(key: .arkitTrackingType, label: "TRACKING TYPE", segments: ["DEVICE", "FACE", "MARKER"], width: 240, value: AppSettingModel.shared.arkitTrackingType.rawValue)),
            ],
        ]
    }

    public func updateSetting(setting: DetailSettingsData) {
        switch setting {
        case .segmented(let data):
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
                // TODO: Move UserDefault update to AppSettingModel?
                AppSettingModel.shared.arkitTrackingType = ArkitTrackingType(rawValue: data.value)!
                Defaults[.userArkitTrackingType] = data.value
            }
        }
    }
}
