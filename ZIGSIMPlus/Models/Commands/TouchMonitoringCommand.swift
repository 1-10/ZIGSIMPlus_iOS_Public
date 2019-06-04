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
        return true
    }
    
    public func start(completion: ((String?) -> Void)?) {
        TouchDataStore.shared.enable()
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        TouchDataStore.shared.disable()
        completion?(nil)
    }
}
