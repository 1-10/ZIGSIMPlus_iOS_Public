//
//  Command.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/10.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public protocol Command: AnyObject {
    func isAvailable() -> Bool
    func start()
    func stop()
}

public protocol ManualUpdatedCommand: Command {
    func monitor()
}

public protocol AutoUpdatedCommand: Command {
}
