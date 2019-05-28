//
//  ProximityMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class ProximityMonitoringCommand: AutoUpdatedCommand {
    public static var shared: Command = ProximityMonitoringCommand()
    private init() {}
    
    public func isAvailable() -> Bool {
        return true
    }

    public func start(completion: ((String?) -> Void)?) {
        ProximityDataStore.shared.start()
        ProximityDataStore.shared.callbackProximity = { proximity in
            completion?("proximitymonitor:proximitymonitor:\(proximity)")
        }
        ProximityDataStore.shared.initialDisplay()
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        ProximityDataStore.shared.stop()
        completion?(nil)
    }
    
}
