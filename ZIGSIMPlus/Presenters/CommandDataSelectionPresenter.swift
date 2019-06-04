//
//  CommandDataSelectionPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

protocol CommandDataSelectionPresenterProtocol {
    var numberOfCommandDataToSelect: Int { get }
    func getCommandDataToSelect(forRow row: Int) -> CommandDataToSelect
    func didSelectRow(atLabel labelString: String)
}

protocol CommandDataSelectionPresenterDelegate: AnyObject {
}

final class CommandDataSelectionPresenter: CommandDataSelectionPresenterProtocol {
    private weak var view: CommandDataSelectionPresenterDelegate!
    private var mediator: CommandAndServiceMediator
    private var commandDataToSelectArray: [CommandDataToSelect] = []
    
    init(view: CommandDataSelectionPresenterDelegate, mediator: CommandAndServiceMediator) {
        self.view = view
        self.mediator = mediator
        updateCommandDataToSelectArray()
    }
    
    var numberOfCommandDataToSelect: Int {
        return commandDataToSelectArray.count
    }
    
    func getCommandDataToSelect(forRow row: Int) -> CommandDataToSelect {
        guard row < commandDataToSelectArray.count else { fatalError("CommandData nil") }
        return commandDataToSelectArray[row]
    }
    
    func didSelectRow(atLabel labelString: String) {
        guard let command = Command(rawValue: labelString) else {
            fatalError("Invalid Command selected: \(labelString)")
        }
        AppSettingModel.shared.isActiveByCommand[command]?.toggle()

        // We need to update commandData because "command.isAvailable" may change by selection
        // e.g. When user enables "ARKit", "Face Tracking" must be disabled
        updateCommandDataToSelectArray()
    }

    // Update all CommandDataToSelect
    private func updateCommandDataToSelectArray() {
        commandDataToSelectArray = [CommandDataToSelect]()
        for command in Command.allCases {
            commandDataToSelectArray.append(CommandDataToSelect(labelString: command.rawValue, isAvailable: mediator.isAvailable(command)))
        }
    }
}

