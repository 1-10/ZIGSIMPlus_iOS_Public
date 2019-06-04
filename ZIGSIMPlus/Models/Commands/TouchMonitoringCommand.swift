//
//  TouchMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public final class TouchMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return TouchService.shared.isAvailable()
    }
    
    public func start() {
        TouchService.shared.enable()
    }
    
    public func stop() {
        TouchService.shared.disable()
    }
}
