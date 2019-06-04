//
//  GpsMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreLocation

public final class GpsMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return LocationDataStore.shared.isLocationAvailable()
    }

    public func start() {
        LocationDataStore.shared.startGps()
    }

    public func stop() {
        LocationDataStore.shared.stopGps()
    }
}
