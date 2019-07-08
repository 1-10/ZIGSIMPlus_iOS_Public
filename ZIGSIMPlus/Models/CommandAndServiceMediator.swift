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

    // MARK: - Private methods

    private static func isCameraAvailable(for command: Command) -> Bool {
        // When camera is set to on by other command,
        // user cannot use camera
        return !AppSettingModel.shared.isCameraUsed(exceptBy: command)
    }
}
