//
//  TouchService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/21.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import DeviceKit
import Foundation
import SwiftOSC
import SwiftyJSON
import UIKit

/// Data store for touch data.
public class TouchService {
    private struct TouchCommandSettings {
        let isTouchActive: Bool
        let isApplePencilActive: Bool
    }

    private struct TouchPayload {
        let point: CGPoint
        let radius: CGFloat
        let force: CGFloat
        let altitudeAngle: CGFloat
        let azimuthAngle: CGFloat
        let isPencil: Bool
    }

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

    func isTouchAvailable() -> Bool {
        return true
    }

    func isApplePencilAvailable() -> Bool {
        return Device.current.isPad
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
            for (i, t) in touchPoints.enumerated() where t == touchToRemove {
                touchPoints.remove(at: i)
                break
            }
        }
    }

    func updateTouches(_ touchesToUpdate: [UITouch]) {
        if !isEnabled { return }

        for touchToUpdate in touchesToUpdate {
            for (i, t) in touchPoints.enumerated() where t == touchToUpdate {
                touchPoints[i] = touchToUpdate
                break
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

    private func commandSettings() -> TouchCommandSettings? {
        guard let isTouchActive = AppSettingModel.shared.isActiveByCommand[Command.touch],
            let isApplePencilActive = AppSettingModel.shared.isActiveByCommand[Command.applePencil]
        else {
            return nil
        }

        return TouchCommandSettings(
            isTouchActive: isTouchActive,
            isApplePencilActive: isApplePencilActive
        )
    }

    private func touchPayload(for touch: UITouch) -> TouchPayload? {
        guard let view = touch.view else {
            return nil
        }

        let point = remapToScreenCoord(touch.location(in: view))
        return TouchPayload(
            point: point,
            radius: touch.majorRadius,
            force: touch.force,
            altitudeAngle: touch.altitudeAngle,
            azimuthAngle: touch.azimuthAngle(in: view),
            isPencil: touch.type == .pencil
        )
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

extension TouchService: Service {
    func toLog() -> [String] {
        guard let settings = commandSettings() else {
            return []
        }

        var result = [String]()

        for touch in touchPoints {
            guard let payload = touchPayload(for: touch) else {
                continue
            }

            if settings.isTouchActive {
                result += [
                    String(format: "touch:x:%.3f", payload.point.x),
                    String(format: "touch:y:%.3f", payload.point.y),
                    String(format: "touch:radius:%.3f", payload.radius),
                    String(format: "touch:force:%.3f", payload.force),
                ]
            }

            if settings.isApplePencilActive, payload.isPencil {
                result += [
                    "pencil:touch:x:\(payload.point.x)",
                    "pencil:touch:y:\(payload.point.y)",
                    "pencil:altitude:\(payload.altitudeAngle)",
                    "pencil:azimuth:\(payload.azimuthAngle)",
                    String(format: "pencil:force:%.3f", payload.force),
                ]
            }
        }

        return result
    }

    func toOSC() -> [OSCMessage] {
        guard let settings = commandSettings() else {
            return []
        }

        if !settings.isTouchActive, !settings.isApplePencilActive {
            return []
        }

        var messages = [OSCMessage]()

        for (i, touch) in touchPoints.enumerated() {
            guard let payload = touchPayload(for: touch) else {
                continue
            }

            if settings.isTouchActive {
                // Position
                messages.append(osc("touch\(i)1", Float(payload.point.x)))
                messages.append(osc("touch\(i)2", Float(payload.point.y)))
                messages.append(osc("touchradius\(i)", Float(payload.radius)))
                messages.append(osc("touchforce\(i)", Float(payload.force)))
            }

            if settings.isApplePencilActive, payload.isPencil {
                messages.append(osc("penciltouch\(i)1", Float(payload.point.x)))
                messages.append(osc("penciltouch\(i)2", Float(payload.point.y)))
                messages.append(osc("pencilaltitude\(i)", Float(payload.altitudeAngle)))
                messages.append(osc("pencilazimuth\(i)", Float(payload.azimuthAngle)))
                messages.append(osc("pencilforce\(i)", Float(payload.force)))
            }
        }

        return messages
    }

    func toJSON() throws -> JSON {
        guard let settings = commandSettings() else {
            return JSON()
        }

        var data = JSON()
        if settings.isTouchActive {
            let touchData: [[String: CGFloat]] = touchPoints.compactMap { touch in
                guard let payload = touchPayload(for: touch) else {
                    return nil
                }

                return [
                    "x": payload.point.x,
                    "y": payload.point.y,
                    "radius": payload.radius,
                    "force": payload.force,
                ]
            }
            data["touch"] = JSON(touchData)
        }

        if settings.isApplePencilActive {
            let pencilData: [[String: CGFloat]] = touchPoints.compactMap { touch in
                guard let payload = touchPayload(for: touch) else {
                    return nil
                }

                return [
                    "x": payload.point.x,
                    "y": payload.point.y,
                    "altitude": payload.altitudeAngle,
                    "azimuth": payload.azimuthAngle,
                    "force": payload.force,
                ]
            }
            data["pencil"] = JSON(pencilData)
        }

        return data
    }
}
