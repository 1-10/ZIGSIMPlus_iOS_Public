//
//  MiscDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/23.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion
import SwiftOSC

/// Data store for tiny data. e.g.) Motion, Battery, etc.
public class MiscDataStore {
    // Singleton instance
    static let shared = MiscDataStore()
    private init() {}
    
    // MARK: - Instance Properties
    
    var battery: Float = 0.0
    var isBatteryError: Bool = false

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

extension MiscDataStore : Store {
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
