//
//  NdiMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/15.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

public final class NdiMonitoringCommand: ImageCommand {
    let ndi = NDI()
    
    public func startImage(callback: ((UIImage) -> Void)?) {
        ndi.start(callback: callback)
    }
    
    public func start(completion: ((String?) -> Void)?) {}
    
    public func stop(completion: ((String?) -> Void)?) {
        ndi.stop()
        completion?("TBD")
    }
}