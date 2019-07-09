//
//  TouchService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit
import SwiftOSC
import SwiftyJSON

/// Data store for touch data.
public class TouchService {
    // Singleton instance
    static let shared = TouchService()

    // MARK: - Instance Properties

    private var isEnabled: Bool
    private var touchPoints: [UITouch]
    private var touchArea: CGRect = CGRect.zero

    private init() {
        isEnabled = false
        touchPoints = [UITouch]()
    }

    // MARK: - Public methods

    func isAvailable() -> Bool {
        return true
    }

    func enable() {
        isEnabled = true
    }

    func disable() {
        isEnabled = false
        touchPoints.removeAll() // Reset data
    }

    func addTouches(_ touches: [UITouch]) {
        if !isEnabled { return }

        touchPoints.append(contentsOf: touches)
    }

    func removeTouches(_ touchesToRemove: [UITouch]) {
        if !isEnabled { return }

        for touchToRemove in touchesToRemove {
            for (i, t) in touchPoints.enumerated() {
                if t == touchToRemove {
                    touchPoints.remove(at: i)
                    break
                }
            }
        }
    }

    func updateTouches(_ touchesToUpdate: [UITouch]) {
        if !isEnabled { return }

        for touchToUpdate in touchesToUpdate {
            for (i, t) in touchPoints.enumerated() {
                if t == touchToUpdate {
                    touchPoints[i] = touchToUpdate
                    break
                }
            }
        }
    }

    func removeAllTouches() {
        if !isEnabled { return }

        touchPoints.removeAll()
    }

    func setTouchArea(rect: CGRect) {
        touchArea = rect
    }

    private func getTouchResult(from touches:[UITouch]) -> [String] {
        guard let isTouchActive = AppSettingModel.shared.isActiveByCommand[Command.touch],
            let isApplePencilActive = AppSettingModel.shared.isActiveByCommand[Command.applePencil]
            else {
                fatalError("AppSetting for the command is nil")
        }

        var result = [String]()

        for touch in touches {
            var point = touch.location(in: touch.view!)
            point = remapToScreenCoord(point)

            if isTouchActive {
                // Position
                result += [
                    String(format: "touch:x:%.3f", point.x),
                    String(format: "touch:y:%.3f", point.y),
                ]

                // touch radius
                if #available(iOS 8.0, *) {
                    result.append(String(format: "touch:radius:%.3f", touch.majorRadius))
                }

                // 3d touch
                if #available(iOS 9.0, *) {
                    result.append(String(format: "touch:force:%.3f", touch.force))
                }
            }

            if isApplePencilActive && touch.type == .pencil {
                result += [
                    "pencil:touch:x:\(point.x)",
                    "pencil:touch:y:\(point.y)",
                    "pencil:altitude:\(touch.altitudeAngle)",
                    "pencil:azimuth:\(touch.azimuthAngle(in: touch.view!))",
                ]
                
                if #available(iOS 9.0, *) {
                    result.append(String(format: "pencil:force:%.3f", touch.force))
                }
            }
        }

        return result
    }

    // Remap values to range [-1, 1]
    private func remapToScreenCoord(_ pos: CGPoint) -> CGPoint {
        let x = (pos.x - touchArea.minX) / touchArea.width
        let y = (pos.y - touchArea.minY) / touchArea.height
        return CGPoint(
            x: min(max(x, 0.0), 1.0) * 2.0 - 1.0,
            y: min(max(y, 0.0), 1.0) * 2.0 - 1.0
        )
    }
}

extension TouchService : Service {
    func toLog() -> [String] {
        return getTouchResult(from: touchPoints)
    }

    func toOSC() -> [OSCMessage] {
        guard let isTouchActive = AppSettingModel.shared.isActiveByCommand[Command.touch],
            let isApplePencilActive = AppSettingModel.shared.isActiveByCommand[Command.applePencil]
            else {
                fatalError("AppSetting for the command is nil")
        }

        if !isTouchActive && !isApplePencilActive {
            return []
        }

        let deviceUUID = AppSettingModel.shared.deviceUUID
        var messages = [OSCMessage]()

        for (i, touch) in touchPoints.enumerated() {
            var point = touch.location(in: touch.view!)
            point = remapToScreenCoord(point)

            if isTouchActive {
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

            if isApplePencilActive && touch.type == .pencil {
                messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/penciltouch\(i)1"), Float(point.x)))
                messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/penciltouch\(i)2"), Float(point.y)))
                messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/pencilaltitude\(i)"), Float(touch.altitudeAngle)))
                messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/pencilazimuth\(i)"), Float(touch.azimuthAngle(in: touch.view!))))
                if #available(iOS 9.0, *) {
                    messages.append(OSCMessage(OSCAddressPattern("/\(deviceUUID)/pencilforce\(i)"), Float(touch.force)))
                }
            }
        }

        return messages
    }

    func toJSON() throws -> JSON {
        guard let isTouchActive = AppSettingModel.shared.isActiveByCommand[Command.touch],
            let isApplePencilActive = AppSettingModel.shared.isActiveByCommand[Command.applePencil]
            else {
                fatalError("AppSetting for the command is nil")
        }
        var data = JSON()

        if isTouchActive {
            let touchData: [Dictionary<String, CGFloat>] = touchPoints.map { touch in
                var point = touch.location(in: touch.view!)
                point = remapToScreenCoord(point)

                var obj = ["x": point.x, "y": point.y]

                if #available(iOS 8.0, *) {
                    obj["radius"] = touch.majorRadius
                }
                if #available(iOS 9.0, *) {
                    obj["force"] = touch.force
                }

                return obj
            }
            data["touch"] = JSON(touchData)
        }

        if isApplePencilActive {
            let pencilData: [Dictionary<String, CGFloat>] = touchPoints.map { touch in
                var point = touch.location(in: touch.view!)
                point = remapToScreenCoord(point)

                var obj = [
                    "x": point.x,
                    "y": point.y,
                    "altitude": touch.altitudeAngle,
                    "azimuth": touch.azimuthAngle(in: touch.view!)
                ]
                if #available(iOS 9.0, *) {
                    obj["force"] = touch.force
                }
                
                return obj
            }
            data["pencil"] = JSON(pencilData)
        }

        return data
    }
}
