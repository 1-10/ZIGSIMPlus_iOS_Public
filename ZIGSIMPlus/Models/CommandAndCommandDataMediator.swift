//
//  CommandAndCommandDataMediator.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public class CommandAndCommandDataMediator {
    public func isActive(command: Command) -> Bool {
        if type(of: command) == MotionMonitoringCommand.self {
            guard let b1 = AppSettingModel.shared.isActiveByCommandData[LabelConstants.acceleration],
                let b2 = AppSettingModel.shared.isActiveByCommandData[LabelConstants.gravity]
                else { fatalError("AppSetting of the CommandData nil") }

            return (b1 || b2)
        } else if type(of: command) == BatteryMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.battery]
                else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == BeaconMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.beacon]
                else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == TouchMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.touch]
            else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == CompassMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.compass]
            else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == GpsMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.gps]
            else { fatalError("AppSetting of the CommandData nil") }
            return b
        }

        fatalError("Unexpected Command")
    }

    public func getCommandOutputOrder(of command: Command) -> Int {
        if type(of: command) == MotionMonitoringCommand.self {
            return 1
        } else if type(of: command) == TouchMonitoringCommand.self {
            return 2
        } else if type(of: command) == CompassMonitoringCommand.self {
            return 3
        } else if type(of: command) == GpsMonitoringCommand.self {
            return 4
        } else if type(of: command) == BeaconMonitoringCommand.self {
            return 11
        } else if type(of: command) == BatteryMonitoringCommand.self {
            return 15
        }

        fatalError("Unexpected Command")
    }
}
