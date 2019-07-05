//
//  CommandSettingPresenter.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/28.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

public enum textFieldName {
    case ipAdress
    case portNumber
    case uuid
}

public enum segmentName {
    case dataDestination
    case dataProtocol
    case messageFormat
    case messageRatePerSecond
}

protocol CommandSettingPresenterProtocol {
    func getUserDefaultTexts() -> Dictionary<textFieldName,String>
    func getUserDefaultSegments() -> Dictionary<segmentName,Int>
    func updateTextsUserDefault(texts: Dictionary<textFieldName, String>)
    func updateSegmentsUserDefault(segmentControls: Dictionary<segmentName, Int>)
    func restorePurchase()
}

protocol CommandSettingPresenterDelegate: AnyObject {
    func showRestorePurchaseResult(isSuccessful: Bool, title: String?, message: String?)
}

final class CommandSettingPresenter: CommandSettingPresenterProtocol {
    private weak var view: CommandSettingPresenterDelegate!
    
    init(view: CommandSettingPresenterDelegate) {
        self.view = view
    }
    
    func getUserDefaultTexts() -> Dictionary<textFieldName,String> {
        var texts:[textFieldName: String] = [:]
        texts[.ipAdress] = Defaults[.userIpAdress].description
        texts[.portNumber] = Defaults[.userPortNumber].description
        texts[.uuid] = Defaults[.userDeviceUUID].description
        return texts
    }
    
    func getUserDefaultSegments() -> Dictionary<segmentName,Int> {
        var segments:[segmentName:Int] = [:]
        segments[.dataDestination] = Defaults[.userDataDestination]
        segments[.dataProtocol] = Defaults[.userProtocol]
        segments[.messageFormat] = Defaults[.userMessageFormat]
        segments[.messageRatePerSecond] = Defaults[.userMessageRatePerSecond]

        return segments
    }
    
    func updateTextsUserDefault(texts: Dictionary<textFieldName, String>) {
        AppSettingModel.shared.address = texts[.ipAdress] ?? ""
        Defaults[.userIpAdress] = AppSettingModel.shared.address
        AppSettingModel.shared.port = Int(texts[.portNumber] ?? "0") ?? 0
        Defaults[.userPortNumber] = AppSettingModel.shared.port
        AppSettingModel.shared.deviceUUID = texts[.uuid] ?? ""
        Defaults[.userDeviceUUID] = AppSettingModel.shared.deviceUUID
    }
    
    func updateSegmentsUserDefault(segmentControls: Dictionary<segmentName, Int>) {
        AppSettingModel.shared.dataDestination = DataDestination(rawValue: segmentControls[.dataDestination] ?? 0)!
        Defaults[.userDataDestination] = AppSettingModel.shared.dataDestination.rawValue
        AppSettingModel.shared.transportProtocol = TransportProtocol(rawValue: segmentControls[.dataProtocol] ?? 0)!
        Defaults[.userProtocol] = AppSettingModel.shared.transportProtocol.rawValue
        AppSettingModel.shared.transportFormat = TransportFormat(rawValue: segmentControls[.messageFormat] ?? 0)!
        Defaults[.userMessageFormat] = AppSettingModel.shared.transportFormat.rawValue
        AppSettingModel.shared.messageRatePerSecondSegment = segmentControls[.messageRatePerSecond] ?? 0
        Defaults[.userMessageRatePerSecond] = AppSettingModel.shared.messageRatePerSecondSegment
    }
    
    func restorePurchase() {
        InAppPurchaseFacade.shared.restorePurchase { (result, error) in
            var title = ""
            var message = ""
            var isSuccessful = false
            
            if result == .restoreSuccessful {
                isSuccessful = true
                title = "Purchase Restored"
                message = """
                Thank you for using ZIG SIM.
                Enjoy!
                """
            } else {
                title = "Restore Failed"
                if let error = error {
                    message = "There was a problem in purchase restore:\n" + error.localizedDescription
                } else {
                    message = "There was a problem in purchase restore."
                }
            }
            
            self.view.showRestorePurchaseResult(isSuccessful: isSuccessful, title: title, message: message)
        }
    }
}
