//
//  BatteryMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

public final class BatteryMonitoringCommand: ManualUpdatedCommand {
    public func isAvailable() -> Bool {
        return true
    }
    
    public func start() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }
    
    public func stop() {
        UIDevice.current.isBatteryMonitoringEnabled = false
    }

    public func monitor() {
        if UIDevice.current.batteryLevel != -1 {
            MiscDataStore.shared.battery = UIDevice.current.batteryLevel
        } else {
//            completion?("battery level unknown")
        }
    }
}
