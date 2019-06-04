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
        return AudioLevelService.shared.isAvailable()
    }
    
    public func start() {
        AudioLevelService.shared.start()
    }
    
    public func stop() {
        AudioLevelService.shared.stop()
    }
}
