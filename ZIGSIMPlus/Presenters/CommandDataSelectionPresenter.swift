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
    func didSelectRow(atLabel label: String)
}

protocol CommandDataSelectionPresenterDelegate: AnyObject {
}

final class CommandDataSelectionPresenter: CommandDataSelectionPresenterProtocol {
    var view: CommandDataSelectionPresenterDelegate!
    private var commandDatasToSelect: [CommandDataToSelect]
    
    init() {
        commandDatasToSelect = [CommandDataToSelect]()
        let mediater = CommandAndCommandDataMediator()
        for label in LabelConstants.commandDatas {
            commandDatasToSelect.append(CommandDataToSelect(label: label, isAvailable: mediater.isAvailable(commandDataLabel: label)))
        }
    }
    
    var numberOfCommandDataToSelect: Int {
        return commandDatasToSelect.count
    }
    
    func getCommandDataToSelect(forRow row: Int) -> CommandDataToSelect? {
        guard row < commandDatasToSelect.count else { return nil }
        return commandDatasToSelect[row]
    }
    
    func didSelectRow(atLabel label: String) {
        AppSettingModel.shared.isActiveByCommandData[label]?.toggle()
    }
}

