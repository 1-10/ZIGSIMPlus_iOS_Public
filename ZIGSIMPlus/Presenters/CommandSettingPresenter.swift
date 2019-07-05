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
        let appSettings = AppSettingModel.shared
        texts[.ipAdress] = appSettings.ipAddress
        texts[.portNumber] = appSettings.portNumber.description
        texts[.uuid] = appSettings.deviceUUID
        return texts
    }
    
    func getUserDefaultSegments() -> Dictionary<segmentName,Int> {
        var segments:[segmentName:Int] = [:]
        let appSettings = AppSettingModel.shared
        segments[.dataDestination] = appSettings.dataDestination.rawValue
        segments[.dataProtocol] = appSettings.transportProtocol.rawValue
        segments[.messageFormat] = appSettings.transportFormat.rawValue
        segments[.messageRatePerSecond] = appSettings.messageRatePerSecond.rawValue

        return segments
    }
    
    func updateTextsUserDefault(texts: Dictionary<textFieldName, String>) {
        let appSettings = AppSettingModel.shared
        appSettings.ipAddress = texts[.ipAdress] ?? ""
        appSettings.portNumber = Int(texts[.portNumber] ?? "0") ?? 0
        appSettings.deviceUUID = texts[.uuid] ?? ""
    }
    
    func updateSegmentsUserDefault(segmentControls: Dictionary<segmentName, Int>) {
        let appSettings = AppSettingModel.shared
        appSettings.dataDestination = DataDestination(rawValue: segmentControls[.dataDestination] ?? 0)!
        appSettings.transportProtocol = TransportProtocol(rawValue: segmentControls[.dataProtocol] ?? 0)!
        appSettings.transportFormat = TransportFormat(rawValue: segmentControls[.messageFormat] ?? 0)!
        appSettings.messageRatePerSecond = RatePerSecond(rawValue: segmentControls[.messageRatePerSecond] ?? 0)!
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
