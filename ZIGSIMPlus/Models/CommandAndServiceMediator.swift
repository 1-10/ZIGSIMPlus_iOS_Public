//
//  CommandAndServiceMediator.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/21.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

public class CommandAndServiceMediator {
    // MARK: - Public methods

    /// Returns if the service for given command is available.
    ///
    /// Simultaneous use of multiple commands accessing camera is not allowed.
    public static func isAvailable(_ command: Command) -> Bool {
        command.isAvailable()
    }

    public static func startCommand(_ command: Command) {
        command.start()
    }

    public static func stopCommand(_ command: Command) {
        command.stop()
    }
}
