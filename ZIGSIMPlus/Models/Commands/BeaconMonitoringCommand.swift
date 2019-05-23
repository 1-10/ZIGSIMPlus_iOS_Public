//
//  BeaconMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class BeaconMonitoringCommand: AutoUpdatedCommand {

    public func start(completion: ((String?) -> Void)?) {
        LocationDataStore.shared.beaconsCallback = { (beacons) in
            var stringMsg = ""
            
            for (i, b) in beacons.enumerated() {
                stringMsg += "Beacon \(i): uuid:\(b.proximityUUID.uuidString) major:\(b.major.intValue) minor:\(b.minor.intValue) rssi:\(b.rssi)\n"
            }
            
            completion?(stringMsg)
        }
        
        LocationDataStore.shared.enable()
    }

    public func stop(completion: ((String?) -> Void)?) {
        LocationDataStore.shared.disable()
        completion?(nil)
    }
}
