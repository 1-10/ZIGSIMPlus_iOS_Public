//
//  TouchMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

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
            
            let result = self.getTouchResult(from: touches, isTouchActive: isTouchActive, isApplePencilActive: isApplePencilActive)
            completion?(result)
        }
        
        TouchDataStore.shared.enable()
    }
    
    private func getTouchResult(from touches:[UITouch], isTouchActive: Bool, isApplePencilActive: Bool) -> String {
        
        var result = ""
        for touch in touches {
            var point = touch.location(in: touch.view!)
            point = Utils.remapToScreenCoord(point)
            
            if isTouchActive {
                // Position
                result.appendLines("""
                    touch:x:\(point.x)
                    touch:y:\(point.y)
                    """)
                
                // touch radius
                if #available(iOS 8.0, *) {
                    result.appendLines("touch:radius:\(touch.majorRadius)")
                }
                
                // 3d touch
                if #available(iOS 9.0, *) {
                    result.appendLines("touch:force:\(touch.force)")
                }
            }
            
            if isApplePencilActive && touch.type == .pencil {
                result.appendLines("""
                    pencil:touch:x:\(point.x)
                    pencil:touch:y:\(point.y)
                    pencil:altitude:\(touch.altitudeAngle)
                    pencil:azimuth:\(touch.azimuthAngle(in: touch.view!))
                    pencil:force:\(touch.force)
                    """)
            }
        }
        
        return result
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        TouchDataStore.shared.disable()
        completion?(nil)
    }
}
