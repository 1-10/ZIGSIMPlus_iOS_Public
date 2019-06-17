//
//  CommandSettingPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/28.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

protocol CommandSettingPresenterProtocol {
    func getUserDefaultTexts() -> Dictionary<String,String>
    func getUserDefaultSegments() -> Dictionary<String,Int>
    func updateTextsUserDefault(texts: Dictionary<String, String>)
    func updateSegmentsUserDefault(segmentControls: Dictionary<String, Int>)
}

protocol CommandSettingPresenterDelegate: AnyObject {}

final class CommandSettingPresenter: CommandSettingPresenterProtocol {
    private weak var view: CommandSettingPresenterDelegate!
    
    init(view: CommandSettingPresenterDelegate) {
        self.view = view
    }
    
    func getUserDefaultTexts() -> Dictionary<String,String> {
        var texts:[String: String] = [
            "ipAdress": "",
            "portNumber": "",
            "uuid": "",
        ]

        texts["ipAdress"] = Defaults[.userIpAdress]?.description ?? ""
        texts["portNumber"] = Defaults[.userPortNumber]?.description ?? ""
        texts["uuid"] = Defaults[.userDeviceUUID]?.description ?? ""
        return texts
    }
    
    func getUserDefaultSegments() -> Dictionary<String,Int> {
        var segments:[String:Int] = [
            "userDataDestination": 0,
            "userProtocol": 0,
            "userMessageFormat": 0,
            "userMessageRatePerSecond": 0
        ]
        
        segments["userDataDestination"] = Defaults[.userDataDestination]
        segments["userProtocol"] = Defaults[.userProtocol]
        segments["userMessageFormat"] = Defaults[.userMessageFormat]
        segments["userMessageRatePerSecond"] = Defaults[.userMessageRatePerSecond]
        
        return segments
    }
    
    func updateTextsUserDefault(texts: Dictionary<String, String>) {
        AppSettingModel.shared.address = texts["ipAdress"]?.description ?? ""
        Defaults[.userIpAdress] = AppSettingModel.shared.address
        AppSettingModel.shared.port = Int32(texts["portNumber"]?.description ?? "") ?? 0
        Defaults[.userPortNumber] = Int(AppSettingModel.shared.port)
        AppSettingModel.shared.deviceUUID = texts["uuid"]?.description ?? ""
        Defaults[.userDeviceUUID] = AppSettingModel.shared.deviceUUID
    }
    
    func updateSegmentsUserDefault(segmentControls: Dictionary<String, Int>) {

        AppSettingModel.shared.dataDestination = DataDestination(rawValue: segmentControls["userDataDestination"] ?? 0)!
        Defaults[.userDataDestination] = AppSettingModel.shared.dataDestination.rawValue

        AppSettingModel.shared.transportProtocol = TransportProtocol(rawValue: segmentControls["userProtocol"] ?? 0)!
        Defaults[.userProtocol] = AppSettingModel.shared.transportProtocol.rawValue

        AppSettingModel.shared.transportFormat = TransportFormat(rawValue: segmentControls["userMessageFormat"] ?? 0)!
        Defaults[.userMessageFormat] = AppSettingModel.shared.transportFormat.rawValue

        AppSettingModel.shared.messageRatePerSecondSegment = segmentControls["userMessageRatePerSecond"] ?? 0
        Defaults[.userMessageRatePerSecond] = AppSettingModel.shared.messageRatePerSecondSegment
    }
}
