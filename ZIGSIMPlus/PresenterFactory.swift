//
//  PresenterFactory.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

class PresenterFactory {
    func createCommandSelectionPresenter(view: CommandSelectionPresenterDelegate) -> CommandSelectionPresenter {
        let presenter = CommandSelectionPresenter()
        presenter.view = view
        return presenter
    }
    
    func createCommandOutputPresenter(view: CommandOutputPresenterDelegate) -> CommandOutputPresenter {
        let presenter = CommandOutputPresenter()
        presenter.view = view
        presenter.autoUpdatedCommands[LabelConstants.accelaration] = AccelerationMonitoringCommand()
        presenter.autoUpdatedCommands[LabelConstants.ndi] = NdiMonitoringCommand()
        presenter.manualUpdatedCommands[LabelConstants.battery] = BatteryMonitoringCommand()
        return presenter
    }
}
