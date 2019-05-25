//
//  BatteryMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

public final class BatteryMonitoringCommand: ManualUpdatedCommand {
    public static let shared: Command = BatteryMonitoringCommand()
    private init() {}
    
    public func isAvailable() -> Bool {
        return true
    }
    
    public func start(completion: ((String?) -> Void)?) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        monitor(completion: completion)
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        UIDevice.current.isBatteryMonitoringEnabled = false
        completion?(nil)
    }

    public func monitor(completion: ((String?) -> Void)?) {
        if UIDevice.current.batteryLevel != -1 {
            MiscDataStore.shared.battery = UIDevice.current.batteryLevel
            completion?("battery:level:\(UIDevice.current.batteryLevel)")
        } else {
            completion?("battery level unknown")
        }
    }
}
