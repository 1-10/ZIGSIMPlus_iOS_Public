//
//  BatteryMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

public final class BatteryMonitoringCommand: Command {
    public func start(completion: ((String?) -> Void)?) {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryLevel != -1 {
            completion?("Battery Level: \(UIDevice.current.batteryLevel)")
        } else {
            completion?("Battery Level Unknown")
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        UIDevice.current.isBatteryMonitoringEnabled = false
        completion?(nil)
    }
}
