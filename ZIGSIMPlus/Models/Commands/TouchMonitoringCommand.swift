//
//  TouchMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class TouchMonitoringCommand: AutoUpdatedCommand {
    
    public func start(completion: ((String?) -> Void)?) {
        TouchDataStore.shared.callback = { (touches) in
            var stringMsg = ""
            
            for touch in touches {
                // Position
                stringMsg += """
                touch:x:\(touch.point.x)
                touch:y:\(touch.point.y)
                
                """
                
                // touch radius
                if #available(iOS 8.0, *) {
                    stringMsg += "touch:radius:\(touch.touch.majorRadius)\n"
                } else {
                    // Fallback on earlier versions
                }
                
                // 3d touch
                if #available(iOS 9.0, *) {
                    stringMsg += "touch:force:\(touch.touch.force)\n"
                } else {
                    // Fallback on earlier versions
                }
                
            }
            
            completion?(stringMsg)
        }
        
        TouchDataStore.shared.enable()
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        TouchDataStore.shared.disable()
        completion?(nil)
    }
}
