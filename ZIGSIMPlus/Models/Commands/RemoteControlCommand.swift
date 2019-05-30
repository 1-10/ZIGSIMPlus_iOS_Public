//
//  RemoteControlCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/29.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class RemoteControlCommand: AutoUpdatedCommand {

    public func start(completion: ((String?) -> Void)?) {
        RemoteControllerDataStore.shared.callback = { (isPlaying, volume) in
            completion?("""
                remotecontroller:playpause \(isPlaying)
                remotecontroller:volume \(volume)
            """)
        }
        RemoteControllerDataStore.shared.start()
    }

    public func stop(completion: ((String?) -> Void)?) {
        RemoteControllerDataStore.shared.stop()
        completion?(nil)
    }

}
