//
//  TouchDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

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
