//
//  ProximityDataStore.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftOSC

public class ProximityDataStore {
    // Singleton instance
    static let shared = ProximityDataStore()
    
    // MARK: - Instance Properties
    var proximity: Bool = false
    var callbackProximity: ((Bool) -> Void)?

    @objc func proximitySensorStateDidChange() {
        self.proximity = UIDevice.current.proximityState
    }
    
    // MARK: - Public methods
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

extension ProximityDataStore : Store {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommandData[Label.proximity]! {
            log += [
                "proximitymonitor:proximitymonitor:\(proximity)"
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var data = [OSCMessage]()
        
        if AppSettingModel.shared.isActiveByCommandData[Label.proximity]! {
            data.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/proximitymonitor"), proximity))
        }
        
        return data
    }
    
    func toJSON() -> [String:AnyObject] {
        var data = [String:AnyObject]()
        
        if AppSettingModel.shared.isActiveByCommandData[Label.proximity]! {
            data.merge([
                "proximitymonitor": [
                    "proximitymonitor": proximity
                    ] as AnyObject
            ]) { $1 }
        }
        
        return data
    }
}

