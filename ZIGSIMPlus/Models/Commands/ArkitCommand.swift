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
        return ArkitDataStore.shared.isAvailable()
    }

    public func start(completion: ((String?) -> Void)?) {
        ArkitDataStore.shared.start()
        ArkitDataStore.shared.callback = { (pos) in
            completion?("""
                arkit:position:x\(pos.x)
                arkit:position:y\(pos.y)
                arkit:position:z\(pos.z)
                """)
        }
    }

    public func stop(completion: ((String?) -> Void)?) {
        ArkitDataStore.shared.stop()
        completion?(nil)
    }
}
