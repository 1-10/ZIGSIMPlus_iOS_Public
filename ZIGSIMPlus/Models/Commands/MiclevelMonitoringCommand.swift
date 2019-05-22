//
//  MiclevelMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class MiclevelMonitoringCommand: AutoUpdatedCommand {
    
    public func start(completion: ((String?) -> Void)?) {
        /* fpsは設定画面から変更できるように修正する↓ */
        AudioLevelData.shared.start(fps: 1)
        AudioLevelData.shared.callbackAudio = { level in
            completion?("""
                miclevel:max\(level[0])
                miclevel:average\(level[1])
                """)
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        AudioLevelData.shared.stop()
        completion?(nil)
    }
}
