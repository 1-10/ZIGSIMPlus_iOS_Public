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
        return true
    }
    
    public func start(completion: ((String?) -> Void)?) {
        AudioLevelDataStore.shared.start(fps: Double(AppSettingModel.shared.messageRatePerSecond))
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        AudioLevelDataStore.shared.stop()
        completion?(nil)
    }
}
