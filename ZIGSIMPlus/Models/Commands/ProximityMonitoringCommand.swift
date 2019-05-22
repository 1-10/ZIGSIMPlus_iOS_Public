//
//  ProximityMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class ProximityMonitoringCommand: AutoUpdatedCommand {
    
    public func start(completion: ((String?) -> Void)?) {
        ProximityData.shared.start()
        ProximityData.shared.callbackProximity = { proximity in
            completion?("proximitymonitor:proximitymonitor:\(proximity)")
        }
        ProximityData.shared.initialDisplay()
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        ProximityData.shared.stop()
        completion?(nil)
    }
    
}
