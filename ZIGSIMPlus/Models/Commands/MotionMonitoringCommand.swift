//
//  MotionMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class MotionMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return MotionService.shared.isAvailable()
    }
    
    public func start() {
        MotionService.shared.start()
    }

    public func stop() {
        MotionService.shared.stop()
    }
}
