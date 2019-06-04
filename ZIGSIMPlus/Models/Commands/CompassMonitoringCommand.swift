//
//  CompassMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreLocation

public final class CompassMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return LocationDataStore.shared.isLocationAvailable()
    }

    public func start() {
        LocationDataStore.shared.startCompass()
    }

    public func stop() {
        LocationDataStore.shared.stopCompass()
    }
}
