//
//  NdiMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/15.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

public final class NdiMonitoringCommand: AutoUpdatedCommand {
    // TODO: This should be updated
    public func isAvailable() -> Bool {
        return true
    }

    public func start(completion: ((String?) -> Void)?) {
        NDIDataStore.shared.start()
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        NDIDataStore.shared.stop()
        completion?(nil)
    }
}
