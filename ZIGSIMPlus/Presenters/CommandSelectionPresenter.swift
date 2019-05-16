//
//  CommandSelectionPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

protocol CommandSelectionPresenterProtocol {
    var numberOfCommandLabels: Int { get }
    func getCommandLabel(forRow row: Int) -> String?
    func didSelectRow(atLabel label: String)
}

protocol CommandSelectionPresenterDelegate: AnyObject {
}

final class CommandSelectionPresenter: CommandSelectionPresenterProtocol {
    var view: CommandSelectionPresenterDelegate!
    
    var numberOfCommandLabels: Int {
        return LabelConstants.commands.count
    }
    
    func getCommandLabel(forRow row: Int) -> String? {
        guard row < LabelConstants.commands.count else { return nil }
        return LabelConstants.commands[row]
    }
    
    func didSelectRow(atLabel label: String) {
        AppSettingModel.shared.isActiveByCommand[label]?.toggle()
    }
}

