//
//  BatteryService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftOSC

/// Data store for battery
public class BatteryService {
    // Singleton instance
    static let shared = BatteryService()
    private init() {}
    
    // MARK: - Instance Properties
    
    var battery: Float = 0.0
    var isBatteryError: Bool = false

    func isAvailable() -> Bool {
        return true
    }

    func startBattery() {
        UIDevice.current.isBatteryMonitoringEnabled = true
    }

    func stopBattery() {
        UIDevice.current.isBatteryMonitoringEnabled = false
    }

    func updateBattery() {
        if UIDevice.current.batteryLevel == -1 {
            isBatteryError = true
        } else {
            isBatteryError = false
            battery = UIDevice.current.batteryLevel
        }
    }
}

extension BatteryService : Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommandData[Label.battery]! {
            if isBatteryError {
                log.append("battery level unknown")
            }
            else {
                log.append("battery:\(battery)")
            }
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var messages = [OSCMessage]()
        
        if AppSettingModel.shared.isActiveByCommandData[Label.battery]! {
            messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/battery"), battery))
        }

        return messages
    }
    
    func toJSON() -> [String:AnyObject] {
        var data = [String:AnyObject]()

        if AppSettingModel.shared.isActiveByCommandData[Label.battery]! {
            data.merge(["battery": battery as AnyObject]) { $1 }
        }

        return data
    }
}
