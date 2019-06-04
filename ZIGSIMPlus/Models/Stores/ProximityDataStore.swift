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
import SwiftyJSON

public class ProximityDataStore {
    // Singleton instance
    static let shared = ProximityDataStore()
    
    // MARK: - Instance Properties
    var proximity:Bool
    var callbackProximity: ((Bool) -> Void)?
    
    private init() {
        self.proximity = false
    }
    
    private func update() {
        print("proximitymonitor:proximitymonitor:\(self.proximity)")
        callbackProximity?(self.proximity)
    }
    
    @objc func proximitySensorStateDidChange() {
        self.proximity = UIDevice.current.proximityState
        update()
    }
    
    // MARK: - Public methods
    public func start() {
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(proximitySensorStateDidChange),
                                               name: UIDevice.proximityStateDidChangeNotification,
                                               object: nil)
    }
    
    public func initialDisplay() {
        update()
    }
    
    public func stop() {
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.proximityStateDidChangeNotification,
                                                  object: nil)
    }
    
}

extension ProximityDataStore : Store {
    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var data = [OSCMessage]()
        
        if AppSettingModel.shared.isActiveByCommandData[Label.proximity]! {
            data.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/proximitymonitor"), proximity))
        }
        
        return data
    }
    
    func toJSON() throws -> JSON {
        var data = JSON()
        
        if AppSettingModel.shared.isActiveByCommandData[Label.proximity]! {
            data["proximitymonitor"] = JSON(proximity)
        }
        
        return data
    }
}

