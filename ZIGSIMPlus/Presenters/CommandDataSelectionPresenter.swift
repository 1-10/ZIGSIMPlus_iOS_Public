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
    func getCommandDataToSelect(forRow row: Int) -> CommandDataToSelect?
    func didSelectRow(atLabel labelString: String)
}

protocol CommandDataSelectionPresenterDelegate: AnyObject {
}

final class CommandDataSelectionPresenter: CommandDataSelectionPresenterProtocol {
    private weak var view: CommandDataSelectionPresenterDelegate!
    private var mediator: CommandAndCommandDataMediator
    private var commandDatasToSelect: [CommandDataToSelect]
    
    init(view: CommandDataSelectionPresenterDelegate, mediator: CommandAndCommandDataMediator) {
        self.view = view
        self.mediator = mediator
        commandDatasToSelect = [CommandDataToSelect]()
        for label in LabelConstants.commandDatas {
            commandDatasToSelect.append(CommandDataToSelect(label: label, isAvailable: mediator.isAvailable(commandDataLabel: label)))
        }
    }
    
    var numberOfCommandDataToSelect: Int {
        return commandDatasToSelect.count
    }
    
    func getCommandDataToSelect(forRow row: Int) -> CommandDataToSelect? {
        guard row < commandDatasToSelect.count else { return nil }
        return commandDatasToSelect[row]
    }
    
    func didSelectRow(atLabel labelString: String) {
        let label = Label(rawValue: labelString)
        if label == nil {
            fatalError("Invalid CommandData selected: \(labelString)")
        }
        AppSettingModel.shared.isActiveByCommandData[label!]?.toggle()
    }
}

