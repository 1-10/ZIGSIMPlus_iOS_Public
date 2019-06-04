//
//  DepthMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/03.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

public final class DepthMonitoringCommand: ImageCommand {
    let ndi = NDI()
    
    // TODO: This should be updated
    public func isAvailable() -> Bool {
        return true
    }
    
    public func startImage(callback: ((UIImage) -> Void)?) {
        ndi.start(type: "depth", callback: callback)
    }
    
    public func start(completion: ((String?) -> Void)?) {
        assertionFailure("NdiMonitoringCommand.start must not be called")
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        ndi.stop()
        completion?(nil)
    }
}
