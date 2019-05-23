//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

enum TransportProtocol {
    case TCP
    case UDP
}

enum TransportFormat {
    case OSC
    case JSON
}

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
    
    var address: String = "172.17.1.20"
    var port: Int32 = 3333
    
    var transportProtocol: TransportProtocol = .UDP
//    var transportProtocol: TransportProtocol = .TCP
    var transportFormat: TransportFormat = .OSC

    // TODO: Save values to device storage like UserDefaults
    let deviceUUID:String = Utils.randomStringWithLength(16)
    let beaconUUID = "B9407F30-F5F8-466E-AFF9-25556B570000"
}
