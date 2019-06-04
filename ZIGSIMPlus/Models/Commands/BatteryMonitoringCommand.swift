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
        MiscDataStore.shared.startBattery()
    }
    
    public func stop() {
        MiscDataStore.shared.stopBattery()
    }

    public func monitor() {
        MiscDataStore.shared.updateBattery()
    }
}
