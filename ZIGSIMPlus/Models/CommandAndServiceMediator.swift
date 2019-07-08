//
//  CommandAndServiceMediator.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/21.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

public class CommandAndServiceMediator {

    // MARK: - Public methods

    /// Returns if the service for given command is available.
    ///
    /// Simultaneous use of multiple commands accessing camera is not allowed.
    public static func isAvailable(_ command: Command) -> Bool {
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
            if isCameraAvailable(for: .arkit) {
                return ArkitService.shared.isARKitAvailable()
            } else {
                return false
            }
        case .remoteControl:
            return RemoteControlService.shared.isAvailable()
        case .ndi:
            if isCameraAvailable(for: .ndi) {
                return VideoCaptureService.shared.isNDIAvailable()
            } else {
                return false
            }
        case .imageDetection:
            if isCameraAvailable(for: .imageDetection) {
                return VideoCaptureService.shared.isImageDetectionAvailable()
            } else {
                return false
            }
        case .nfc:
            return NFCService.shared.isAvailable()
        }
    }

    public static func isPremiumCommand(_ command: Command) -> Bool {
        if command == Command.ndi ||
            command == Command.arkit ||
            command == Command.imageDetection ||
            command == Command.nfc ||
            command == Command.applePencil{
            return true
        }
        return false
    }

    public static func startCommand(_ command: Command) {
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

    public static func stopCommand(_ command: Command) {
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

    // MARK: - Private methods

    private static func isCameraAvailable(for command: Command) -> Bool {
        // When camera is set to on by other command,
        // user cannot use camera
        return !AppSettingModel.shared.isCameraUsed(exceptBy: command)
    }
}
