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
        presenter.commands.append(MotionMonitoringCommand.shared)
        presenter.commands.append(TouchMonitoringCommand.shared)
        presenter.commands.append(BatteryMonitoringCommand.shared)
        presenter.commands.append(CompassMonitoringCommand.shared)
        presenter.commands.append(GpsMonitoringCommand.shared)
        presenter.commands.append(BeaconMonitoringCommand.shared)
        return presenter
    }
}
