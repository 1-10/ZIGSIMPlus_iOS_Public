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
        return MotionDataStore.shared.isAvailable()
    }
    
    public func start() {
        MotionDataStore.shared.start()
    }

    public func stop() {
        MotionDataStore.shared.stop()
    }
}
