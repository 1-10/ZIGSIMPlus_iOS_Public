//
//  CommandDataSettingPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/28.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

protocol CommandDataSettingPresenterProtocol {
    func getUserDefaultTexts() -> Dictionary<String,String>
    func getUserDefaultSegments() -> Dictionary<String,Int>
    func updateTextsUserDefault(texts: Dictionary<String, String>)
    func updateSegmentsUserDefault(segmentControls: Dictionary<String, Int>)
}

protocol CommandDataSettingPresenterDelegate: AnyObject {}

final class CommandDataSettingPresenter: CommandDataSettingPresenterProtocol {
    private weak var view: CommandDataSettingPresenterDelegate!
    
    init(view: CommandDataSettingPresenterDelegate) {
        self.view = view
    }
    
    func getUserDefaultTexts() -> Dictionary<String,String> {
        var texts:[String: String] = [
            "ipAdress": "",
            "portNumber": "",
            "uuid": "",
            "beaconUUID1": "",
            "beaconUUID2": "",
            "beaconUUID3": "",
            "beaconUUID4": "",
            "beaconUUID5": ""
        ]

        texts["ipAdress"] = Defaults[.userIpAdress]?.description ?? ""
        texts["portNumber"] = Defaults[.userPortNumber]?.description ?? ""
        texts["uuid"] = Defaults[.userDeviceUUID]?.description ?? ""
        texts["beaconUUID1"] = Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]?.description ?? "", position:0)
        texts["beaconUUID2"] = Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]?.description ?? "", position:1)
        texts["beaconUUID3"] = Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]?.description ?? "", position:2)
        texts["beaconUUID4"] = Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]?.description ?? "", position:3)
        texts["beaconUUID5"] = Utils.separateBeaconUuid(uuid: Defaults[.userBeaconUUID]?.description ?? "", position:4)
        return texts
    }
    
    func getUserDefaultSegments() -> Dictionary<String,Int> {
        var segments:[String:Int] = [
            "userDataDestination": 0,
            "userProtocol": 0,
            "userMessageFormat": 0,
            "userMessageRatePerSecond": 0,
            "userCompassAngle": 0
        ]
        
        segments["userDataDestination"] = Defaults[.userDataDestination]
        segments["userProtocol"] = Defaults[.userProtocol]
        segments["userMessageFormat"] = Defaults[.userMessageFormat]
        segments["userMessageRatePerSecond"] = Defaults[.userMessageRatePerSecond]
        segments["userCompassAngle"] = Defaults[.userCompassAngle]
        
        return segments
    }
    
    func updateTextsUserDefault(texts: Dictionary<String, String>) {
        AppSettingModel.shared.address = texts["ipAdress"]?.description ?? ""
        Defaults[.userIpAdress] = AppSettingModel.shared.address
        AppSettingModel.shared.port = Int32(texts["portNumber"]?.description ?? "") ?? 0
        Defaults[.userPortNumber] = Int(AppSettingModel.shared.port)
        AppSettingModel.shared.deviceUUID = texts["uuid"]?.description ?? ""
        Defaults[.userDeviceUUID] = AppSettingModel.shared.deviceUUID
        var beaconUUID = texts["beaconUUID1"]?.description ?? ""
        beaconUUID += "-"
        beaconUUID += texts["beaconUUID2"]?.description ?? ""
        beaconUUID += "-"
        beaconUUID += texts["beaconUUID3"]?.description ?? ""
        beaconUUID += "-"
        beaconUUID += texts["beaconUUID4"]?.description ?? ""
        beaconUUID += "-"
        beaconUUID += texts["beaconUUID5"]?.description ?? ""
        AppSettingModel.shared.beaconUUID = beaconUUID
        Defaults[.userBeaconUUID] = AppSettingModel.shared.beaconUUID
        print("beaconuuid: \(AppSettingModel.shared.beaconUUID)")
    }
    
    func updateSegmentsUserDefault(segmentControls: Dictionary<String, Int>) {

        AppSettingModel.shared.dataDestination = DataDestination(rawValue: segmentControls["userDataDestination"] ?? 0)!
        Defaults[.userDataDestination] = AppSettingModel.shared.dataDestination.rawValue

        AppSettingModel.shared.transportProtocol = TransportProtocol(rawValue: segmentControls["userProtocol"] ?? 0)!
        Defaults[.userProtocol] = AppSettingModel.shared.transportProtocol.rawValue

        AppSettingModel.shared.transportFormat = TransportFormat(rawValue: segmentControls["userMessageFormat"] ?? 0)!
        Defaults[.userMessageFormat] = AppSettingModel.shared.transportFormat.rawValue

        AppSettingModel.shared.messageRatePerSecond = segmentControls["userMessageRatePerSecond"] ?? 0
        Defaults[.userMessageRatePerSecond] = AppSettingModel.shared.messageRatePerSecond
        
        AppSettingModel.shared.faceup = segmentControls["userCompassAngle"] ?? 0
        Defaults[.userCompassAngle] = AppSettingModel.shared.faceup
    }
}
