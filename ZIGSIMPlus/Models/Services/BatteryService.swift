//
//  BatteryService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftOSC
import SwiftyJSON

/// Data store for battery
public class BatteryService {
    // Singleton instance
    static let shared = BatteryService()

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

extension BatteryService: Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommand[Command.battery]! {
            if isBatteryError {
                log.append("battery level unknown")
            } else {
                log.append("battery:\(battery)")
            }
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        var messages = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.battery]! {
            messages.append(osc("battery", battery))
        }

        return messages
    }

    func toJSON() throws -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommand[Command.battery]! {
            data["battery"] = JSON(battery)
        }

        return data
    }
}
