//
//  ProximityMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

public final class ProximityMonitoringCommand: AutoUpdatedCommand {
    
    private var proximity = false
    private var timer: Timer?
    
    public func start(completion: ((String?) -> Void)?) {
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(proximitySensorStateDidChange),
                                               name: UIDevice.proximityStateDidChangeNotification,
                                               object: nil)
        self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(ProximityMonitoringCommand.completion), userInfo: completion, repeats: true)
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        self.timer?.invalidate()
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.proximityStateDidChangeNotification,
                                                  object: nil)
        completion?(nil)
    }
    
    @objc func proximitySensorStateDidChange() {
        self.proximity = UIDevice.current.proximityState
    }
    
    @objc func completion(_ timer: Timer!) {
        let completion = timer.userInfo as! (String?) -> Void
        completion("proximitymonitor:proximitymonitor:\(self.proximity)")
    }
}
