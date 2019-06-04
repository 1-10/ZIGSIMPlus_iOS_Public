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

    public func start() {
        RemoteControlDataStore.shared.start()
    }

    public func stop() {
        RemoteControlDataStore.shared.stop()
    }
}
