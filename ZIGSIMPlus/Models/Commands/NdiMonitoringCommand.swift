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
    public func isAvailable() -> Bool {
        return NDIDataStore.isAvailable()
    }

    public func start() {
        NDIDataStore.shared.start()
    }
    
    public func stop() {
        NDIDataStore.shared.stop()
    }
}
