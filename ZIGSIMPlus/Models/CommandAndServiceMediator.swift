//
//  CommandAndServiceMediator.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public class CommandAndServiceMediator {

    // MARK: - Public methods

    /// Returns if the service for given command is available
    public func isAvailable(_ command: Command) -> Bool {
        switch command {
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
            return ArkitService.shared.isARKitAvailable()
        case .remoteControl:
            return RemoteControlService.shared.isAvailable()
        case .ndi:
            return VideoCaptureService.shared.isNDIAvailable()
        case .imageDetection:
            return VideoCaptureService.shared.isImageDetectionAvailable()
        case .nfc:
            return NFCService.shared.isAvailable()
        }
    }

    public func startActiveCommands() {
        for command in Command.allCases {
            if isActive(command) {
                startCommand(command)
            }
        }
    }

    /// Call update methods for active commands
    public func monitorManualCommands() {
        if isActive(.battery) {
            BatteryService.shared.updateBattery()
        }
    }

    public func stopActiveCommands() {
        for command in Command.allCases {
            if isActive(command) {
                stopCommand(command)
            }
        }
    }

    // MARK: - Private methods

    private func startCommand(_ command: Command) {
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
            ArkitService.shared.start()
        case .remoteControl:
            RemoteControlService.shared.start()
        case .ndi, .imageDetection:
            VideoCaptureService.shared.start()
        case .nfc:
            NFCService.shared.start()
        }
    }

    private func stopCommand(_ command: Command) {
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
            ArkitService.shared.stop()
        case .remoteControl:
            RemoteControlService.shared.stop()
        case .ndi, .imageDetection:
            VideoCaptureService.shared.stop()
        case .nfc:
            NFCService.shared.stop()
        }
    }

    private func isActive(_ command: Command) -> Bool {
        guard let b = AppSettingModel.shared.isActiveByCommand[command] else {
            fatalError("AppSetting for Command \"\(command)\" is nil")
        }
        return b
    }
}
