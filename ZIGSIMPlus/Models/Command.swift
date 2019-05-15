//
//  Command.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/10.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public protocol Command: AnyObject {
    func start(completion: ((String?) -> Void)?)
    func stop(completion: ((String?) -> Void)?)
}
