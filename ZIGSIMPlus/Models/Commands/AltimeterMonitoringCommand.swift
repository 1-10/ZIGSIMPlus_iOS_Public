//
//  AltimeterMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/20.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion

public final class AltimeterMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return AltimeterService.shared.isAvailable()
    }
    
    public func start() {
        AltimeterService.shared.startAltimeter()
    }
    
    public func stop() {
        AltimeterService.shared.stopAltimeter()
    }
}

