//
//  RemoteControlCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/29.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class RemoteControlCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return RemoteControlDataStore.shared.isAvailable()
    }

    public func start(completion: ((String?) -> Void)?) {
        RemoteControlDataStore.shared.start()
    }

    public func stop(completion: ((String?) -> Void)?) {
        RemoteControlDataStore.shared.stop()
        completion?(nil)
    }
}
