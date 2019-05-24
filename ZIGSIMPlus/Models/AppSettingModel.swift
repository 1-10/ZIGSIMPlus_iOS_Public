//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum DataDestination {
    case LOCAL_FILE
    case OTHER_APP
}

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
    
    // app default value & variable used in app
    var dataDestination: DataDestination = .OTHER_APP
    var transportProtocol: TransportProtocol = .UDP
    var adress: String = "192.168.0.1"
    var port: Int32 = 50000
    var transportFormat: TransportFormat = .OSC
    var messageRatePerSecond: Int = 60
    var deviceUUID: String = Utils.randomStringWithLength(16)
    var compassAngle: Double = 1.0 // 1.0 is faceup
    var beaconUUID = "B9407F30-F5F8-466E-AFF9-25556B570000"
    var messageInterval: TimeInterval {
        return 1.0 / Double(messageRatePerSecond)
    }
}

// user default data
extension DefaultsKeys {
    static let userDataDestination = DefaultsKey<Int?>("userDataDestination", defaultValue: 1)
    static let userProtocol = DefaultsKey<Int?>("userProtocol", defaultValue: 1)
    static let userIpAdress = DefaultsKey<String?>("userIpAdress", defaultValue: AppSettingModel.shared.adress)
    static let userPortNumber = DefaultsKey<Int?>("userPortNumber", defaultValue: Int(AppSettingModel.shared.port))
    static let userMessageFormat = DefaultsKey<Int?>("userMessageFormat", defaultValue: 0)
    static let userMessageRatePerSecond = DefaultsKey<Int?>("userMessageRatePerSecond", defaultValue: AppSettingModel.shared.messageRatePerSecond)
    static let userCompassAngle = DefaultsKey<Double?>("userCompassAngle", defaultValue: AppSettingModel.shared.compassAngle)
    static let userDeviceUUID = DefaultsKey<String?>("userDeviceUUID", defaultValue: AppSettingModel.shared.deviceUUID)
    static let userBeaconUUID = DefaultsKey<String?>("userBeaconUUID", defaultValue: AppSettingModel.shared.beaconUUID)
}
