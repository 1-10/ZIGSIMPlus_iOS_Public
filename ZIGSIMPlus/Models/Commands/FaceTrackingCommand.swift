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
        return ArkitDataStore.shared.isFaceTrackingAvailable()
    }

    public func start(completion: ((String?) -> Void)?) {
        ArkitDataStore.shared.startFaceTracking()
        ArkitDataStore.shared.faceTrackingCallback = { (pos, rot, lpos, rpos) in
            completion?("""
                face:position:(\(String(format: "%.5f, %.5f, %.5f", pos.x, pos.y, pos.z)))
                face:rotation:(\(String(format: "%.5f, %.5f, %.5f", rot.x, rot.y, rot.z)))
                face:leftEyePosition:(\(String(format: "%.5f, %.5f, %.5f", lpos.x, lpos.y, lpos.z)))
                face:rightEyePosition:(\(String(format: "%.5f, %.5f, %.5f", rpos.x, rpos.y, rpos.z)))
                """)
        }
    }

    public func stop(completion: ((String?) -> Void)?) {
        ArkitDataStore.shared.stopDeviceTracking()
        completion?(nil)
    }
}
