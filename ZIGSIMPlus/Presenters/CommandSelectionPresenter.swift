//
//  CommandSelectionPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

protocol CommandSelectionPresenterProtocol {
    var isPremiumFeaturePurchased: Bool { get }
    var numberOfCommandToSelect: Int { get }
    func getCommandToSelect(forRow row: Int) -> CommandToSelect
    func didSelectRow(atLabel labelString: String)
}

protocol CommandSelectionPresenterDelegate: AnyObject {
}

final class CommandSelectionPresenter: CommandSelectionPresenterProtocol {
    private weak var view: CommandSelectionPresenterDelegate!
    private var mediator: CommandAndServiceMediator
    private var CommandToSelectArray: [CommandToSelect] = []
    private let purchaceFacade: InAppPurchaseFacade = InAppPurchaseFacade()
    
    init(view: CommandSelectionPresenterDelegate, mediator: CommandAndServiceMediator) {
        self.view = view
        self.mediator = mediator
        updateCommandToSelectArray()
    }
    
    var isPremiumFeaturePurchased: Bool {
        return purchaceFacade.isPurchased()
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

    // Update all CommandToSelect
    private func updateCommandToSelectArray() {
        CommandToSelectArray = [CommandToSelect]()
        for command in Command.allCases {
            CommandToSelectArray.append(CommandToSelect(labelString: command.rawValue, isAvailable: mediator.isAvailable(command)))
        }
    }
}

