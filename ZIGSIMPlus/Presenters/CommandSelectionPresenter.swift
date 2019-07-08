//
//  CommandSelectionPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

protocol CommandSelectionPresenterProtocol {
    var isPremiumFeaturePurchased: Bool { get }
    var numberOfCommandToSelect: Int { get }
    func getCommandToSelect(forRow row: Int) -> CommandToSelect
    func didSelectRow(atLabel labelString: String)
    func purchase()
    func saveCommandOnOffToUserDefaults(_ command: Command,_ isOn: Bool)
    func loadCommandOnOffFromUserDefaults()
}

protocol CommandSelectionPresenterDelegate: AnyObject {
    func showPurchaseResult(isSuccessful: Bool, title: String?, message: String?)
}

final class CommandSelectionPresenter: CommandSelectionPresenterProtocol {
    private weak var view: CommandSelectionPresenterDelegate!
    private var CommandToSelectArray: [CommandToSelect] = []
    
    init(view: CommandSelectionPresenterDelegate) {
        self.view = view
        updateCommandToSelectArray()
    }
    
    var isPremiumFeaturePurchased: Bool {
        return InAppPurchaseFacade.shared.isPurchased()
    }
    
    var numberOfCommandToSelect: Int {
        return CommandToSelectArray.count
    }
    
    func getCommandToSelect(forRow row: Int) -> CommandToSelect {
        guard row < CommandToSelectArray.count else { fatalError("Command nil") }
        return CommandToSelectArray[row]
    }
    
    func didSelectRow(atLabel labelString: String) {
        guard let command = Command(rawValue: labelString) else {
            fatalError("Invalid Command selected: \(labelString)")
        }
        AppSettingModel.shared.isActiveByCommand[command]?.toggle()

        // We need to update Command because "command.isAvailable" may change by selection
        // e.g. When user enables "ARKit", "Face Tracking" must be disabled
        updateCommandToSelectArray()
    }
    
    func purchase() {
        InAppPurchaseFacade.shared.purchase { (result, error) in
            var title = ""
            var message = ""
            var isSuccessful = false
            
            if result == .purchaseSuccessful {
                isSuccessful = true
                title = "Purchase Successful"
                message = """
                Thank you for purchasing.
                Enjoy!
                """
            } else {
                title = "Purchase Failed"
                if let error = error {
                    message = "There was a problem in purchase:\n" + error.localizedDescription
                } else {
                    message = "There was a problem in purchase."
                }
            }
            
            self.view.showPurchaseResult(isSuccessful: isSuccessful, title: title, message: message)
        }
    }
    
    func saveCommandOnOffToUserDefaults(_ command: Command, _ isOn: Bool) {
        Defaults[command.userDefaultsKey] = isOn
    }
    
    func loadCommandOnOffFromUserDefaults() {
        for command in Command.allCases {
            AppSettingModel.shared.isActiveByCommand[command] = Defaults[command.userDefaultsKey]
        }
    }

    // Update all CommandToSelect
    private func updateCommandToSelectArray() {
        CommandToSelectArray = [CommandToSelect]()
        for command in Command.allCases {
            CommandToSelectArray.append(CommandToSelect(labelString: command.rawValue, isAvailable: CommandAndServiceMediator.isAvailable(command)))
        }
    }
}

