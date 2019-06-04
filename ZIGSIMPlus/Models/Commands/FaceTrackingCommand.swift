//
//  FaceTrackingCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/30.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SceneKit

public final class FaceTrackingCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return ArkitService.shared.isFaceTrackingAvailable()
    }

    public func start() {
        ArkitService.shared.startFaceTracking()
    }

    public func stop() {
        ArkitService.shared.stopFaceTracking()
    }
}
