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
    private var mediator: CommandAndCommandDataMediator
    private var commandDatasToSelect: [CommandDataToSelect] = []
    
    init(view: CommandDataSelectionPresenterDelegate, mediator: CommandAndCommandDataMediator) {
        self.view = view
        self.mediator = mediator
        updateCommandData()
    }
    
    var numberOfCommandDataToSelect: Int {
        return commandDatasToSelect.count
    }
    
    func getCommandDataToSelect(forRow row: Int) -> CommandDataToSelect {
        guard row < commandDatasToSelect.count else { fatalError("CommandData nil") }
        return commandDatasToSelect[row]
    }
    
    func didSelectRow(atLabel labelString: String) {
        guard let label = Label(rawValue: labelString) else {
            fatalError("Invalid CommandData selected: \(labelString)")
        }
        AppSettingModel.shared.isActiveByCommandData[label]?.toggle()

        // We need to update commandData because "command.isAvailable" may change by selection
        // e.g. When user enables "ARKit", "Face Tracking" must be disabled
        updateCommandData()
    }

    // Update commands availability
    private func updateCommandData() {
        commandDatasToSelect = [CommandDataToSelect]()
        for label in CommandDataLabels {
            commandDatasToSelect.append(CommandDataToSelect(labelString: label.rawValue, isAvailable: mediator.isAvailable(commandDataLabel: label)))
        }
    }
}

