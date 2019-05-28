//
//  TouchDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit
import SwiftOSC

/// Data store for touch data.
public class TouchDataStore {
    // Singleton instance
    static let shared = TouchDataStore()
    
    // MARK: - Instance Properties
    
    var isEnabled: Bool
    var touchPoints: [UITouch]
    var callback: (([UITouch]) -> Void)?

    private init() {
        isEnabled = false
        touchPoints = [UITouch]()
        callback = nil
    }
    
    // MARK: - Public methods
    
    func enable() {
        isEnabled = true
    }
    
    func disable() {
        isEnabled = false
        touchPoints.removeAll() // Reset data
    }
    
    func addTouches(_ touches: Set<UITouch>) {
        if !isEnabled { return }
        
        touchPoints.append(contentsOf: touches)
        update()
    }
    
    func removeTouches(_ touchesToRemove: Set<UITouch>) {
        if !isEnabled { return }
        
        for touchToRemove in touchesToRemove {
            for (i, t) in touchPoints.enumerated() {
                if t == touchToRemove {
                    touchPoints.remove(at: i)
                    break
                }
            }
        }
        update()
    }
    
    func updateTouches(_ touchesToUpdate: Set<UITouch>) {
        if !isEnabled { return }

        for touchToUpdate in touchesToUpdate {
            for (i, t) in touchPoints.enumerated() {
                if t == touchToUpdate {
                    touchPoints[i] = touchToUpdate
                    break
                }
            }
        }
        update()
    }

    func removeAllTouches() {
        if !isEnabled { return }
        
        touchPoints.removeAll()
        update()
    }
    
    private func update() {
        print("touchpoint:\(touchPoints.count)")
        callback?(touchPoints)
    }
}

extension TouchDataStore : Store {
    func toOSC() -> [OSCMessage] {
        if !AppSettingModel.shared.isActiveByCommandData[Label.touch]! {
            return []
        }
        
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var messages = [OSCMessage]()
            
        for (i, touch) in touchPoints.enumerated() {
            var point = touch.location(in: touch.view!)
            point = Utils.remapToScreenCoord(point)

            // Position
            messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touch\(i)1"), Float(point.x)))
            messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touch\(i)2"), Float(point.y)))

            if #available(iOS 8.0, *) {
                messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touchradius\(i)"), Float(touch.majorRadius)))
            }
            if #available(iOS 9.0, *) {
                messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/touchforce\(i)"), Float(touch.force)))
            }
        }
        
        return messages
    }
    
    func toJSON() -> [String:AnyObject] {
        if !AppSettingModel.shared.isActiveByCommandData[Label.touch]! {
            return [:]
        }
        
        let objs: [Dictionary<String, CGFloat>] = touchPoints.map { touch in
            var point = touch.location(in: touch.view!)
            point = Utils.remapToScreenCoord(point)

            var obj = ["x": point.x, "y": point.y]
            
            if #available(iOS 8.0, *) {
                obj["radius"] = touch.majorRadius
            }
            if #available(iOS 9.0, *) {
                obj["force"] = touch.force
            }
            
            return obj
        }
        return ["touches": objs as AnyObject]
    }
}
