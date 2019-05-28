//
//  CommandAndCommandDataMediator.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public class CommandAndCommandDataMediator {
    public let commands: [Command] = [
        MotionMonitoringCommand(),
        TouchMonitoringCommand(),
        BatteryMonitoringCommand(),
        CompassMonitoringCommand(),
        AltimeterMonitoringCommand(),
        GpsMonitoringCommand(),
        BeaconMonitoringCommand(),
        ProximityMonitoringCommand(),
        MicLevelMonitoringCommand(),
        NdiMonitoringCommand()
    ]
    
    public func isAvailable(commandDataLabel: String) -> Bool {
        return getCommand(by: commandDataLabel).isAvailable()
    }
    
    public func getCommand(by commandDataLabel: String) -> Command {
        switch commandDataLabel {
        case LabelConstants.acceleration, LabelConstants.gravity, LabelConstants.gyro, LabelConstants.quaternion:
            return getCommand(by: MotionMonitoringCommand.self)
        case LabelConstants.touch:
            return getCommand(by: TouchMonitoringCommand.self)
        case LabelConstants.battery:
            return getCommand(by: BatteryMonitoringCommand.self)
        case LabelConstants.compass:
            return getCommand(by: CompassMonitoringCommand.self)
        case LabelConstants.pressure:
            return getCommand(by: AltimeterMonitoringCommand.self)
        case LabelConstants.gps:
            return getCommand(by: GpsMonitoringCommand.self)
        case LabelConstants.beacon:
            return getCommand(by: BeaconMonitoringCommand.self)
        case LabelConstants.proximity:
            return getCommand(by: ProximityMonitoringCommand.self)
        case LabelConstants.micLevel:
            return getCommand(by: MicLevelMonitoringCommand.self)
        case LabelConstants.ndi:
            return getCommand(by: NdiMonitoringCommand.self)
        default:
            fatalError("Unexpected Command Data Label")
        }
    }
    
    public func getCommand<T: Command> (by commandType: T.Type) -> Command {
        for command in commands {
            if type(of: command) == commandType {
                return command
            }
        }
        
        fatalError("Unexpected Command Type")
    }
    
    public func isActive(command: Command) -> Bool {
        if type(of: command) == MotionMonitoringCommand.self {
            guard let b1 = AppSettingModel.shared.isActiveByCommandData[LabelConstants.acceleration],
                let b2 = AppSettingModel.shared.isActiveByCommandData[LabelConstants.gravity],
                let b3 = AppSettingModel.shared.isActiveByCommandData[LabelConstants.gyro],
                let b4 = AppSettingModel.shared.isActiveByCommandData[LabelConstants.quaternion]
                else { fatalError("AppSetting of the CommandData nil") }

            return (b1 || b2 || b3 || b4)
        } else if type(of: command) == BatteryMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.battery]
                else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == NdiMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.ndi]
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
        } else if type(of: command) == AltimeterMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.pressure]
                else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == GpsMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.gps]
            else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == ProximityMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.proximity]
                else { fatalError("AppSetting of the CommandData nil") }
            return b
        } else if type(of: command) == MicLevelMonitoringCommand.self {
            guard let b = AppSettingModel.shared.isActiveByCommandData[LabelConstants.micLevel]
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
        } else if type(of: command) == AltimeterMonitoringCommand.self {
            return 4
        } else if type(of: command) == GpsMonitoringCommand.self {
            return 5
        } else if type(of: command) == BeaconMonitoringCommand.self {
            return 11
        } else if type(of: command) == ProximityMonitoringCommand.self {
            return 12
        } else if type(of: command) == MicLevelMonitoringCommand.self {
            return 13
        } else if type(of: command) == BatteryMonitoringCommand.self {
            return 15
        } else if type(of: command) == NdiMonitoringCommand.self {
            return 22
        }

        fatalError("Unexpected Command")
    }
}
