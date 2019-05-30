//
//  ArkitCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/30.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SceneKit

public final class ArkitCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return ArkitDataStore.shared.isDeviceTrackingAvailable()
    }

    public func start(completion: ((String?) -> Void)?) {
        ArkitDataStore.shared.startDeviceTracking()
        ArkitDataStore.shared.deviceTrackingCallback = { (pos, rot, featurePoints) in
            completion?("""
                arkit:position:(\(String(format: "%.5f, %.5f, %.5f", pos.x, pos.y, pos.z)))
                arkit:rotation:(\(String(format: "%.5f, %.5f, %.5f", rot.x, rot.y, rot.z)))
                arkit:featurePoints: \(featurePoints.count)
                """)
        }
    }

    public func stop(completion: ((String?) -> Void)?) {
        ArkitDataStore.shared.stopDeviceTracking()
        completion?(nil)
    }
}
