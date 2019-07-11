//
//  ProximityService.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftOSC
import SwiftyJSON
import UIKit

public class ProximityService {
    // Singleton instance
    static let shared = ProximityService()

    // MARK: - Instance Properties

    var proximity: Bool = false
    var callbackProximity: ((Bool) -> Void)?

    @objc func proximitySensorStateDidChange() {
        proximity = UIDevice.current.proximityState
    }

    // MARK: - Public methods

    func isAvailable() -> Bool {
        return true
    }

    public func start() {
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(proximitySensorStateDidChange),
                                               name: UIDevice.proximityStateDidChangeNotification,
                                               object: nil)
    }

    public func stop() {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.proximityStateDidChangeNotification,
                                                  object: nil)
    }
}

extension ProximityService: Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommand[Command.proximity]! {
            log += [
                "proximitymonitor:proximitymonitor:\(proximity)",
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        var data = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.proximity]! {
            data.append(osc("proximitymonitor", proximity ? 1 : 0))
        }

        return data
    }

    func toJSON() throws -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommand[Command.proximity]! {
            data["proximitymonitor"] = JSON(["proximitymonitor": proximity])
        }

        return data
    }
}
