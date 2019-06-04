//
//  CommandAndCommandDataMediator.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public class CommandAndServiceMediator {

    public func isAvailable(_ commandLabel: Label) -> Bool {
        switch commandLabel {
        case .acceleration, .gravity, .gyro, .quaternion:
            return MotionService.shared.isAvailable()
        case .touch, .applePencil:
            return TouchService.shared.isAvailable()
        case .battery:
            return BatteryService.shared.isAvailable()
        case .compass, .gps, .beacon:
            return LocationService.shared.isLocationAvailable()
        case .pressure:
            return AltimeterService.shared.isAvailable()
        case .proximity:
            return ProximityService.shared.isAvailable()
        case .micLevel:
            return AudioLevelService.shared.isAvailable()
        case .arkit:
            return ArkitService.shared.isDeviceTrackingAvailable()
        case .faceTracking:
            return ArkitService.shared.isFaceTrackingAvailable()
        case .remoteControl:
            return RemoteControlService.shared.isAvailable()
        case .ndi:
            return NDIService.shared.isAvailable()
        }
    }

    public func startCommand(_ command: Label) {
        switch command {
        case .acceleration, .gravity, .gyro, .quaternion:
            MotionService.shared.start()
        case .touch, .applePencil:
            TouchService.shared.enable()
        case .battery:
            BatteryService.shared.startBattery()
        case .compass:
            LocationService.shared.startCompass()
        case .gps:
            LocationService.shared.startGps()
        case .beacon:
            LocationService.shared.startBeacons()
        case .pressure:
            AltimeterService.shared.startAltimeter()
        case .proximity:
            ProximityService.shared.start()
        case .micLevel:
            AudioLevelService.shared.start()
        case .arkit:
            ArkitService.shared.startDeviceTracking()
        case .faceTracking:
            ArkitService.shared.startFaceTracking()
        case .remoteControl:
            RemoteControlService.shared.start()
        case .ndi:
            NDIService.shared.start()
        }
    }

    public func stopCommand(_ command: Label) {
        switch command {
        case .acceleration, .gravity, .gyro, .quaternion:
            MotionService.shared.stop()
        case .touch, .applePencil:
            TouchService.shared.disable()
        case .battery:
            BatteryService.shared.stopBattery()
        case .compass:
            LocationService.shared.stopCompass()
        case .gps:
            LocationService.shared.stopGps()
        case .beacon:
            LocationService.shared.stopBeacons()
        case .pressure:
            AltimeterService.shared.stopAltimeter()
        case .proximity:
            ProximityService.shared.stop()
        case .micLevel:
            AudioLevelService.shared.stop()
        case .arkit:
            ArkitService.shared.stopDeviceTracking()
        case .faceTracking:
            ArkitService.shared.stopFaceTracking()
        case .remoteControl:
            RemoteControlService.shared.stop()
        case .ndi:
            NDIService.shared.stop()
        }
    }

    public func isManual(_ label: Label) -> Bool {
        switch label {
        case .battery: return true
        default: return false
        }
    }

    public func update(_ command: Label) {
        switch command {
        case .battery:
            BatteryService.shared.updateBattery()
        default:
            // TODO: provide more typesafe way if possible
            assertionFailure("Command \"\(command)\" must not be updated manually")
        }
    }

    public func isActive(_ label: Label) -> Bool {
        guard let b = AppSettingModel.shared.isActiveByCommandData[label] else {
            fatalError("AppSetting for Command \"\(label)\" is nil")
        }
        return b
    }
}
