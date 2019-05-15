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
    private let commandLabelList = [LabelConstants.Accelaration, LabelConstants.Battery]
    var view: CommandSelectionPresenterDelegate!
    
    var numberOfCommandLabels: Int {
        return commandLabelList.count
    }
    
    func getCommandLabel(forRow row: Int) -> String? {
        guard row < commandLabelList.count else { return nil }
        return commandLabelList[row]
    }
    
    func didSelectRow(atLabel label: String) {
        switch label {
        case LabelConstants.Accelaration:
            AppSettingModel.shared.isAccelerationMonitoringActive.toggle()
        case LabelConstants.Battery:
            AppSettingModel.shared.isBatteryMonitoringActive.toggle()
        default:
            break
        }
    }
}

