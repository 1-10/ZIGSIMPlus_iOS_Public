//
//  MiclevelMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class MicLevelMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return AudioLevelDataStore.shared.isAvailable()
    }
    
    public func start() {
        AudioLevelDataStore.shared.start()
    }
    
    public func stop() {
        AudioLevelDataStore.shared.stop()
    }
}
