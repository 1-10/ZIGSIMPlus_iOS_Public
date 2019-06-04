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
        return BatteryService.shared.isAvailable()
    }
    
    public func start() {
        BatteryService.shared.startBattery()
    }
    
    public func stop() {
        BatteryService.shared.stopBattery()
    }

    public func monitor() {
        BatteryService.shared.updateBattery()
    }
}
