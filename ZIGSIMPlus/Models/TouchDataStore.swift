//
//  TouchDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

public struct TouchData {
    let touch: UITouch
    let point: CGPoint
//    public var hash(into hasher: inout Hasher) {
//        get {
//            return touch.hashValue &* 31 &+ point.hashValue
//        }
//    }
}

public class TouchDataStore {
    // Singleton instance
    static let shared = TouchDataStore()
    
    // MARK: - Instance Properties
    
    var isEnabled: Bool
    var touchPoints: [TouchData]
    var callback: (([TouchData]) -> Void)?

    private init() {
        isEnabled = false
        touchPoints = [TouchData]()
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
    
    func addTouches(_ touches: [TouchData]) {
        if !isEnabled { return }
        
        touchPoints.append(contentsOf: touches)
        update()
    }
    
    func removeTouches(_ touchesToRemove: [TouchData]) {
        if !isEnabled { return }
        
        for touchToRemove in touchesToRemove {
            for (i, t) in touchPoints.enumerated() {
                if t.touch == touchToRemove.touch {
                    touchPoints.remove(at: i)
                    break
                }
            }
        }
        update()
    }
    
    func updateTouches(_ touchesToUpdate: [TouchData]) {
        if !isEnabled { return }

        for touchToUpdate in touchesToUpdate {
            for (i, t) in touchPoints.enumerated() {
                if t.touch == touchToUpdate.touch {
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
