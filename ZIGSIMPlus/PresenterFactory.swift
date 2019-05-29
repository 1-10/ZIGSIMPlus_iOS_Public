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
        presenter.commands.append(TouchMonitoringCommand())
        presenter.commands.append(BatteryMonitoringCommand())
        presenter.commands.append(CompassMonitoringCommand())
        presenter.commands.append(AltimeterMonitoringCommand())
        presenter.commands.append(GpsMonitoringCommand())
        presenter.commands.append(BeaconMonitoringCommand())
        presenter.commands.append(ProximityMonitoringCommand())
        presenter.commands.append(MicLevelMonitoringCommand())
        presenter.commands.append(NdiMonitoringCommand())
        return presenter
    }
    
    func createCommandDataSettingPresenter(view: CommandDataSettingPresenterDelegate) -> CommandDataSettingPresenter {
        let presenter = CommandDataSettingPresenter()
        presenter.view = view
        presenter.initUserDefault()
        return presenter
    }
}
