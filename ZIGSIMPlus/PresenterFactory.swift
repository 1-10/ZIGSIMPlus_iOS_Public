//
//  PresenterFactory.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

class PresenterFactory {
    func createCommandDataSelectionPresenter(view: CommandDataSelectionPresenterDelegate) -> CommandDataSelectionPresenter {
        let presenter = CommandDataSelectionPresenter()
        presenter.view = view
        return presenter
    }
    
    func createCommandDataOutputPresenter(view: CommandDataOutputPresenterDelegate) -> CommandDataOutputPresenter {
        let presenter = CommandDataOutputPresenter()
        presenter.view = view
        let mediator = CommandAndCommandDataMediator()
        presenter.mediator = mediator
        presenter.commands.append(MotionMonitoringCommand())
        presenter.commands.append(BatteryMonitoringCommand())
        return presenter
    }
}
