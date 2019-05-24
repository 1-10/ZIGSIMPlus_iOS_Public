//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public class AppSettingModel {
    private init() {
        for label in LabelConstants.commandDatas {
            isActiveByCommandData[label] = false
        }
    }
    
    static let shared = AppSettingModel()
    var isActiveByCommandData: Dictionary<String, Bool> = [:]
    
    // app default data & variable used in app
    var dataDestination: String = "OTHER_APP"
    var protocolo: String = "UDP"
    var ipAdress: String = "192.168.0.1"
    var portNumber: String = "50000"
    var messageFormat: String = "JSON"
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
    static let userDataDestination = DefaultsKey<String?>("userDataDestination", defaultValue: AppSettingModel.shared.dataDestination)
    static let userProtocolo = DefaultsKey<String?>("userProtocolo", defaultValue: AppSettingModel.shared.protocolo)
    static let userIpAdress = DefaultsKey<String?>("userIpAdress", defaultValue: AppSettingModel.shared.ipAdress)
    static let userPortNumber = DefaultsKey<String?>("userPortNumber", defaultValue: AppSettingModel.shared.portNumber)
    static let userMessageFormat = DefaultsKey<String?>("userMessageFormat", defaultValue: AppSettingModel.shared.messageFormat)
    static let userMessageRatePerSecond = DefaultsKey<Int?>("userMessageRatePerSecond", defaultValue: AppSettingModel.shared.messageRatePerSecond)
    static let userCompassAngle = DefaultsKey<Double?>("userCompassAngle", defaultValue: AppSettingModel.shared.compassAngle)
    static let userDeviceUUID = DefaultsKey<String?>("userDeviceUUID", defaultValue: AppSettingModel.shared.deviceUUID)
    static let userBeaconUUID = DefaultsKey<String?>("userBeaconUUID", defaultValue: AppSettingModel.shared.beaconUUID)
}
