//
//  Command.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/10.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public protocol Command: AnyObject {
    static var shared: Command { get }
    func isAvailable() -> Bool
    func start(completion: ((String?) -> Void)?)
    func stop(completion: ((String?) -> Void)?)
}

public protocol ManualUpdatedCommand: Command {
    func monitor(completion: ((String?) -> Void)?)
}

public protocol AutoUpdatedCommand: Command {
}
