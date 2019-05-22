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
    func didSelectRow(atLabel label: String)
}

protocol CommandDataSelectionPresenterDelegate: AnyObject {
}

final class CommandDataSelectionPresenter: CommandDataSelectionPresenterProtocol {
    var view: CommandDataSelectionPresenterDelegate!
    
    var numberOfCommandDataLabels: Int {
        return LabelConstants.commandDatas.count
    }
    
    func getCommandDataLabel(forRow row: Int) -> String? {
        guard row < LabelConstants.commandDatas.count else { return nil }
        return LabelConstants.commandDatas[row]
    }
    
    func didSelectRow(atLabel label: String) {
        AppSettingModel.shared.isActiveByCommandData[label]?.toggle()
    }
}

