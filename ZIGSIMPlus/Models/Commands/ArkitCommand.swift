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
        return ArkitService.shared.isDeviceTrackingAvailable()
    }

    public func start() {
        ArkitService.shared.startDeviceTracking()
    }

    public func stop() {
        ArkitService.shared.stopDeviceTracking()
    }
}
