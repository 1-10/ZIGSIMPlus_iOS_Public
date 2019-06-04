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
        return ProximityService.shared.isAvailable()
    }

    public func start() {
        ProximityService.shared.start()
    }
    
    public func stop() {
        ProximityService.shared.stop()
    }
    
}
