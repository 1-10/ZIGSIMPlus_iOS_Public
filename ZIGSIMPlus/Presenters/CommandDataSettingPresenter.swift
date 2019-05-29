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
    func initUserDefault()
    func getUserDefaultTexts() -> Dictionary<String,String>
    func getUserDefaultSegments() -> Dictionary<String,Int>
    func updateTextsUserDefault(texts: Dictionary<String, String>)
    func updateSegmentsUserDefault(segmentControls: Dictionary<String, Int>)
}

protocol CommandDataSettingPresenterDelegate: AnyObject {}

final class CommandDataSettingPresenter: CommandDataSettingPresenterProtocol {
    var view: CommandDataSettingPresenterDelegate!
    func initUserDefault(){
        AppSettingModel.shared.address = Defaults[.userIpAdress]?.description ?? ""
        AppSettingModel.shared.port = Int32(Defaults[.userPortNumber]?.description ?? "") ?? 0
        AppSettingModel.shared.deviceUUID = Defaults[.userDeviceUUID]?.description ?? ""
        AppSettingModel.shared.beaconUUID = Defaults[.userBeaconUUID]?.description ?? ""

        if Defaults[.userDataDestination] == 0 {
            AppSettingModel.shared.dataDestination = .LOCAL_FILE
        } else if Defaults[.userDataDestination] == 1 {
            AppSettingModel.shared.dataDestination = .OTHER_APP
        }
        if Defaults[.userProtocol] == 0 {
            AppSettingModel.shared.transportProtocol = .UDP
        } else if Defaults[.userProtocol] == 1 {
            AppSettingModel.shared.transportProtocol = .TCP
        }
        if Defaults[.userMessageFormat] == 0 {
            AppSettingModel.shared.transportFormat = .JSON
        } else if Defaults[.userMessageFormat] == 1 {
            AppSettingModel.shared.transportFormat = .OSC
        }
        if  Defaults[.userMessageRatePerSecond] == 1 {
            AppSettingModel.shared.messageRatePerSecond = 1
        } else if Defaults[.userMessageRatePerSecond] == 10 {
            AppSettingModel.shared.messageRatePerSecond = 10
        } else if Defaults[.userMessageRatePerSecond] == 30 {
            AppSettingModel.shared.messageRatePerSecond = 30
        } else if Defaults[.userMessageRatePerSecond] == 60 {
            AppSettingModel.shared.messageRatePerSecond = 60
        }
        if Defaults[.userCompassAngle] == 0.0 {
            AppSettingModel.shared.compassAngle = 0.0
        } else if Defaults[.userCompassAngle] == 1.0 {
            AppSettingModel.shared.compassAngle = 1.0
        }
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
        
        if Defaults[.userDataDestination] == 0 {
            segments["userDataDestination"] = 0
        } else if Defaults[.userDataDestination] == 1 {
            segments["userDataDestination"] = 1
        }
        if Defaults[.userProtocol] == 0 {
            segments["userProtocol"] = 0
        } else if Defaults[.userProtocol] == 1 {
            segments["userProtocol"] = 1
        }
        if Defaults[.userMessageFormat] == 0 {
            segments["userMessageFormat"] = 0
        } else if Defaults[.userMessageFormat] == 1 {
            segments["userMessageFormat"] = 1
        }
        if  Defaults[.userMessageRatePerSecond] == 1 {
            segments["userMessageRatePerSecond"] = 0
        } else if Defaults[.userMessageRatePerSecond] == 10 {
            segments["userMessageRatePerSecond"] = 1
        } else if Defaults[.userMessageRatePerSecond] == 30 {
            segments["userMessageRatePerSecond"] = 2
        } else if Defaults[.userMessageRatePerSecond] == 60 {
            segments["userMessageRatePerSecond"] = 3
        }
        if Defaults[.userCompassAngle] == 0.0 {
            segments["userCompassAngle"] = 0
        } else if Defaults[.userCompassAngle] == 1.0 {
            segments["userCompassAngle"] = 1
        }
        
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
    }
    
    func updateSegmentsUserDefault(segmentControls: Dictionary<String, Int>) {
        if segmentControls["userDataDestination"] == 0 {
            AppSettingModel.shared.dataDestination = .LOCAL_FILE
            Defaults[.userDataDestination] = 0
        } else if segmentControls["userDataDestination"] == 1 {
            AppSettingModel.shared.dataDestination = .OTHER_APP
            Defaults[.userDataDestination] = 1
        }
        if segmentControls["userProtocol"] == 0 {
            AppSettingModel.shared.transportProtocol = .UDP
            Defaults[.userProtocol] = 0
        } else if segmentControls["userProtocol"] == 1 {
            AppSettingModel.shared.transportProtocol = .TCP
            Defaults[.userProtocol] = 1
        }
        if segmentControls["userMessageFormat"] == 0 {
            AppSettingModel.shared.transportFormat = .JSON
            Defaults[.userMessageFormat] = 0
        } else if segmentControls["userMessageFormat"] == 1 {
            AppSettingModel.shared.transportFormat = .OSC
            Defaults[.userMessageFormat] = 1
        }
        if segmentControls["userMessageRatePerSecond"] == 0 {
            AppSettingModel.shared.messageRatePerSecond = 1
        } else if segmentControls["userMessageRatePerSecond"] == 1 {
            AppSettingModel.shared.messageRatePerSecond = 10
        } else if segmentControls["userMessageRatePerSecond"] == 2 {
            AppSettingModel.shared.messageRatePerSecond = 30
        } else if segmentControls["userMessageRatePerSecond"] == 3 {
            AppSettingModel.shared.messageRatePerSecond = 60
        }
        Defaults[.userMessageRatePerSecond] = AppSettingModel.shared.messageRatePerSecond
        if segmentControls["userCompassAngle"] == 0 {
            AppSettingModel.shared.compassAngle = 0.0
        } else if segmentControls["userCompassAngle"] == 1 {
            AppSettingModel.shared.compassAngle = 1.0
        }
        Defaults[.userCompassAngle] = AppSettingModel.shared.compassAngle
    }
}
