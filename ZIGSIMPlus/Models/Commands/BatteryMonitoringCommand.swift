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
        return BatteryDataStore.shared.isAvailable()
    }
    
    public func start() {
        BatteryDataStore.shared.startBattery()
    }
    
    public func stop() {
        BatteryDataStore.shared.stopBattery()
    }

    public func monitor() {
        BatteryDataStore.shared.updateBattery()
    }
}
