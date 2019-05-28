//
//  CommandDataSelectionPresenter.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

protocol CommandDataSelectionPresenterProtocol {
    var numberOfCommandDataLabels: Int { get }
    func getCommandDataLabel(forRow row: Int) -> String?
    func didSelectRow(atLabel labelString: String)
}

protocol CommandDataSelectionPresenterDelegate: AnyObject {
}

final class CommandDataSelectionPresenter: CommandDataSelectionPresenterProtocol {
    var view: CommandDataSelectionPresenterDelegate!
    
    var numberOfCommandDataLabels: Int {
        return CommandDataLabels.count
    }
    
    func getCommandDataLabel(forRow row: Int) -> String? {
        guard row < CommandDataLabels.count else { return nil }
        return CommandDataLabels[row].rawValue
    }
    
    func didSelectRow(atLabel labelString: String) {
        let label = Label(rawValue: labelString)
        if label == nil {
            fatalError("Invalid CommandData selected: \(labelString)")
        }
        AppSettingModel.shared.isActiveByCommandData[label!]?.toggle()
    }
}

