//
//  CommandSelectionPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

protocol CommandSelectionPresenterProtocol: AnyObject {
    var numberOfCommandToSelect: Int { get }
    func getCommandToSelect(forRow row: Int) -> CommandToSelect
    func didSelectRow(atLabel labelString: String)
    func saveCommandOnOffToUserDefaults(_ command: Command, _ isOn: Bool)
    func loadCommandOnOffFromUserDefaults()
}

protocol CommandSelectionPresenterDelegate: AnyObject {}

final class CommandSelectionPresenter: CommandSelectionPresenterProtocol {
    private weak var view: CommandSelectionPresenterDelegate!
    private var commandToSelectArray: [CommandToSelect] = []

    init(view: CommandSelectionPresenterDelegate) {
        self.view = view
        updateCommandToSelectArray()
    }

    var numberOfCommandToSelect: Int {
        return commandToSelectArray.count
    }

    func getCommandToSelect(forRow row: Int) -> CommandToSelect {
        guard row < commandToSelectArray.count else { fatalError("Command nil") }
        return commandToSelectArray[row]
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

    func saveCommandOnOffToUserDefaults(_ command: Command, _ isOn: Bool) {
        UserDefaults.standard.set(isOn, forKey: command.userDefaultsKey)
    }

    func loadCommandOnOffFromUserDefaults() {
        for command in Command.allCases {
            AppSettingModel.shared.isActiveByCommand[command] = UserDefaults.standard.bool(forKey: command.userDefaultsKey)
        }
    }

    // Update all CommandToSelect
    private func updateCommandToSelectArray() {
        commandToSelectArray = [CommandToSelect]()
        for command in Command.allCases {
            let cmd = CommandToSelect(
                labelString: command.rawValue,
                isAvailable: CommandAndServiceMediator.isAvailable(command)
            )
            commandToSelectArray.append(cmd)
        }
    }
}
