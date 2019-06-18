//
//  ArkitDetailPresenter.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum ArkitDetailInputType {
    case trackingMode
}

protocol ArkitDetailPresenterProtocol {
    func getUserDefault() -> Dictionary<ArkitDetailInputType,Int>
    func updateArkitTrackingTypeUserDefault(selectIndex: Int)
}

final class ArkitDetailPresenter: ArkitDetailPresenterProtocol {
    func getUserDefault() -> Dictionary<ArkitDetailInputType, Int> {
        return [
            .trackingMode: Defaults[.userArkitTrackingType] ?? 0
        ]
    }

    func updateArkitTrackingTypeUserDefault(selectIndex: Int) {
        // TODO: Move UserDefault update to AppSettingModel
        AppSettingModel.shared.arkitTrackingType = ArkitTrackingType(rawValue: selectIndex)!
        Defaults[.userArkitTrackingType] = selectIndex
    }
}
