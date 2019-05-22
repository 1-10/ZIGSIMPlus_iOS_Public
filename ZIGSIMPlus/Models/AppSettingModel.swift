//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public class AppSettingModel {
    private init() {
        for label in LabelConstants.commandDatas {
            isActiveByCommandData[label] = false
        }
    }
    
    static let shared = AppSettingModel()
    var isActiveByCommandData: Dictionary<String, Bool> = [:]
    var messageRatePerSecond: Int = 60
    
    var messageInterval: TimeInterval {
        return 1.0 / Double(messageRatePerSecond)
    }
    
    let beaconUUID = "B9407F30-F5F8-466E-AFF9-25556B570000" // TODO: Get value from settings view
}
