//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum DataDestination: Int {
    case LOCAL_FILE = 0
    case OTHER_APP = 1
}

enum TransportProtocol: Int {
    case UDP = 0
    case TCP = 1
}

enum TransportFormat: Int {
    case JSON = 0
    case OSC = 1
}

public class AppSettingModel {
    private init() {
        for label in CommandDataLabels {
            isActiveByCommandData[label] = false
        }
        
        address = Defaults[.userIpAdress]?.description ?? ""
        port = Int32(Defaults[.userPortNumber]?.description ?? "") ?? 0
        deviceUUID = Defaults[.userDeviceUUID]?.description ?? ""
        beaconUUID = Defaults[.userBeaconUUID]?.description ?? ""
        dataDestination = DataDestination(rawValue: Defaults[.userDataDestination] ?? 0)!
        transportProtocol = TransportProtocol(rawValue: Defaults[.userProtocol] ?? 0)!
        transportFormat = TransportFormat(rawValue: Defaults[.userMessageFormat] ?? 0)!
        messageRatePerSecond = Defaults[.userMessageRatePerSecond] ?? 0
        faceup = Defaults[.userCompassAngle] ?? 0
    }
    
    static let shared = AppSettingModel()
    var isActiveByCommandData: Dictionary<Label, Bool> = [:]
    
    // app default value & variable used in app
    var dataDestination: DataDestination = .OTHER_APP
    var transportProtocol: TransportProtocol = .UDP
    // var transportProtocol: TransportProtocol = .TCP
    var address: String = "172.17.1.20"
    var port: Int32 = 3333
    var transportFormat: TransportFormat = .OSC
    // var transportFormat: TransportFormat = .JSON
    var messageRatePerSecond: Int = 3
    var deviceUUID: String = Utils.randomStringWithLength(16)
    var faceup: Int = 1 // 1.0 is faceup
    var beaconUUID = "B9407F30-F5F8-466E-AFF9-25556B570000"
    var messageInterval: TimeInterval {
        var convertMessageRatePerSecond = 0
        if messageRatePerSecond == 0 {
            convertMessageRatePerSecond = 1
        } else if messageRatePerSecond == 1 {
            convertMessageRatePerSecond = 10
        } else if messageRatePerSecond == 2 {
            convertMessageRatePerSecond = 30
        } else if messageRatePerSecond == 3 {
            convertMessageRatePerSecond = 60
        }
        return 1.0 / Double(convertMessageRatePerSecond)
    }
    var compassAngle: Double {
        return Double(faceup)
    }
}

// user default value
extension DefaultsKeys {
    static let userDataDestination = DefaultsKey<Int?>("userDataDestination", defaultValue: 1)
    static let userProtocol = DefaultsKey<Int?>("userProtocol", defaultValue: 0)
    static let userIpAdress = DefaultsKey<String?>("userIpAdress", defaultValue: "172.17.1.20")
    static let userPortNumber = DefaultsKey<Int?>("userPortNumber", defaultValue: 3333)
    static let userMessageFormat = DefaultsKey<Int?>("userMessageFormat", defaultValue: 1)
    static let userMessageRatePerSecond = DefaultsKey<Int?>("userMessageRatePerSecond", defaultValue: 3)
    static let userCompassAngle = DefaultsKey<Int?>("userCompassAngle", defaultValue: 1)
    static let userDeviceUUID = DefaultsKey<String?>("userDeviceUUID", defaultValue: Utils.randomStringWithLength(16))
    static let userBeaconUUID = DefaultsKey<String?>("userBeaconUUID", defaultValue: "B9407F30-F5F8-466E-AFF9-25556B570000")
}
