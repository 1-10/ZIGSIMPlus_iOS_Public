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
        switch command {
        case is MotionMonitoringCommand:
            return (
                isCommandDataActive(Label.acceleration) ||
                    isCommandDataActive(Label.gravity) ||
                    isCommandDataActive(Label.gyro) ||
                    isCommandDataActive(Label.quaternion)
            )
        case is BatteryMonitoringCommand:
            return isCommandDataActive(Label.battery)
        case is NdiMonitoringCommand:
            return isCommandDataActive(Label.ndi)
        case is BeaconMonitoringCommand:
            return isCommandDataActive(Label.beacon)
        case is TouchMonitoringCommand:
            return isCommandDataActive(Label.touch)
        case is CompassMonitoringCommand:
            return isCommandDataActive(Label.compass)
        case is AltimeterMonitoringCommand:
            return isCommandDataActive(Label.pressure)
        case is GpsMonitoringCommand:
            return isCommandDataActive(Label.gps)
        case is ProximityMonitoringCommand:
            return isCommandDataActive(Label.proximity)
        case is MicLevelMonitoringCommand:
            return isCommandDataActive(Label.micLevel)
        default:
            fatalError("Unexpected Command")
        }
    }

    public func getCommandOutputOrder(of command: Command) -> Int {
        switch command {
        case is MotionMonitoringCommand: return 1
        case is TouchMonitoringCommand: return 2
        case is CompassMonitoringCommand: return 3
        case is AltimeterMonitoringCommand: return 4
        case is GpsMonitoringCommand: return 5
        case is BeaconMonitoringCommand: return 11
        case is ProximityMonitoringCommand: return 12
        case is MicLevelMonitoringCommand: return 13
        case is BatteryMonitoringCommand: return 15
        case is NdiMonitoringCommand: return 22
        default: fatalError("Unexpected Command")
        }
    }

    private func isCommandDataActive(_ key: Label) -> Bool {
        let b = AppSettingModel.shared.isActiveByCommandData[key]
        if b == nil {
            fatalError("AppSetting for CommandData \"\(key)\" is nil")
        }
        return b!
    }
}
