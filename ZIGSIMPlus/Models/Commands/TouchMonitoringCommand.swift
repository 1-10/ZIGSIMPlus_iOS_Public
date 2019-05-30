//
//  TouchMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public final class TouchMonitoringCommand: AutoUpdatedCommand {
    public func isAvailable() -> Bool {
        return true
    }
    
    public func start(completion: ((String?) -> Void)?) {
        TouchDataStore.shared.callback = { (touches) in
            
            guard let isTouchActive = AppSettingModel.shared.isActiveByCommandData[Label.touch],
                let isApplePencilActive = AppSettingModel.shared.isActiveByCommandData[Label.applePencil]
                else {
                    fatalError("AppSetting of the CommandData nil")
            }
            
            var stringMsg = ""
            
            for touch in touches {
                var point = touch.location(in: touch.view!)
                point = Utils.remapToScreenCoord(point)

                if isTouchActive {
                    // Position
                    stringMsg += """
                    touch:x:\(point.x)
                    touch:y:\(point.y)
                    
                    """
                    
                    // touch radius
                    if #available(iOS 8.0, *) {
                        stringMsg += "touch:radius:\(touch.majorRadius)\n"
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    // 3d touch
                    if #available(iOS 9.0, *) {
                        stringMsg += "touch:force:\(touch.force)\n"
                    } else {
                        // Fallback on earlier versions
                    }
                }
                
                if isApplePencilActive && touch.type == .pencil {
                    stringMsg += """
                    pencil:touch:x:\(point.x)
                    pencil:touch:y:\(point.y)
                    pencil:altitude:\(touch.altitudeAngle)
                    pencil:azimuth:\(touch.azimuthAngle(in: touch.view!))
                    pencil:force:\(touch.force)
                    """
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
