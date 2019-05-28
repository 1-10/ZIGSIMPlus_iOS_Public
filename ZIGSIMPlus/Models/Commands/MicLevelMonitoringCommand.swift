//
//  MiclevelMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class MicLevelMonitoringCommand: AutoUpdatedCommand {
    public static var shared: Command = MicLevelMonitoringCommand()
    private init() {}
    
    public func isAvailable() -> Bool {
        return true
    }
    
    public func start(completion: ((String?) -> Void)?) {
        AudioLevelDataStore.shared.start(fps: Double(AppSettingModel.shared.messageRatePerSecond))
        AudioLevelDataStore.shared.callbackAudio = { level in
            completion?("""
                miclevel:max\(level[0])
                miclevel:average\(level[1])
                """)
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        AudioLevelDataStore.shared.stop()
        completion?(nil)
    }
}
