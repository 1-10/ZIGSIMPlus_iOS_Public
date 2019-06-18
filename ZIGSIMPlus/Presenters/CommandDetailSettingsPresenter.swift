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
    case arkitTrackingType = 0
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
            .arkit: [
                .segmented(DetailSettingsSegmented(key: .arkitTrackingType, label: "TRACKING TYPE", segments: ["DEVICE", "FACE", "MARKER"], width: 240, value: AppSettingModel.shared.arkitTrackingType.rawValue))
            ]
        ]
    }

    public func updateSetting(setting: DetailSettingsData) {
        switch setting {
        case .segmented(let data):
            switch data.key {
            case .arkitTrackingType:
                // TODO: Move UserDefault update to AppSettingModel?
                AppSettingModel.shared.arkitTrackingType = ArkitTrackingType(rawValue: data.value)!
                Defaults[.userArkitTrackingType] = data.value
            }
        }
    }
}
