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
    
    public func start(completion: ((String?) -> Void)?) {
        AltimeterDataStore.shared.startAltimeter()
        AltimeterDataStore.shared.callbackAltimeter = { (altimeterData) in
            completion?("""
                pressure:pressure:\(altimeterData[0])
                pressure:altitude:\(altimeterData[1])
                """)
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        AltimeterDataStore.shared.stopAltimeter()
        completion?(nil)
    }
}

