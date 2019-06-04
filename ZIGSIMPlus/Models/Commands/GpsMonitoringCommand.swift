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
        return LocationService.shared.isLocationAvailable()
    }

    public func start() {
        LocationService.shared.startGps()
    }

    public func stop() {
        LocationService.shared.stopGps()
    }
}
