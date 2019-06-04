//
//  ProximityMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class ProximityMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return ProximityDataStore.shared.isAvailable()
    }

    public func start() {
        ProximityDataStore.shared.start()
    }
    
    public func stop() {
        ProximityDataStore.shared.stop()
    }
    
}
