//
//  BeaconMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class BeaconMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return LocationDataStore.shared.isLocationAvailable()
    }

    public func start() {
        LocationDataStore.shared.startBeacons()
    }

    public func stop() {
        LocationDataStore.shared.stopBeacons()
    }
}
