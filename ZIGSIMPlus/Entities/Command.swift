//
//  Command.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

/// Command is a constant label corresponds to features.
/// NOTE: the order of cases affects selection view.
public enum Command: String, CaseIterable {
    case ndi = "NDI"
    case arkit = "ARKit"
    case imageDetection = "Image Detection"
    case nfc = "NFC Reader"
    case applePencil = "Apple Pencil"
    case acceleration = "Acceleration"
    case gravity = "Gravity"
    case gyro = "Gyro"
    case quaternion = "Quaternion"
    case compass = "Compass"
    case pressure = "Pressure"
    case gps = "GPS"
    case touch = "Touch"
    case beacon = "Beacon"
    case proximity = "Proximity"
    case micLevel = "Mic Level"
    case remoteControl = "Remote Control"
    case battery = "Battery"

    var userDefaultsKey: DefaultsKey<Bool> {
        switch self {
        case .ndi: return DefaultsKeys.isNdiCommandActive
        case .arkit: return DefaultsKeys.isArkitCommandActive
        case .imageDetection: return DefaultsKeys.isImageDetectionCommandActive
        case .nfc: return DefaultsKeys.isNfcReaderCommandActive
        case .applePencil: return DefaultsKeys.isApplePencilCommandActive
        case .acceleration: return DefaultsKeys.isAccelerationCommandActive
        case .gravity: return DefaultsKeys.isGravityCommandActive
        case .gyro: return DefaultsKeys.isGyroCommandActive
        case .quaternion: return DefaultsKeys.isQuaternionCommandActive
        case .compass: return DefaultsKeys.isCompassCommandActive
        case .pressure: return DefaultsKeys.isPressureCommandActive
        case .gps: return DefaultsKeys.isGpsCommandActive
        case .touch: return DefaultsKeys.isTouchCommandActive
        case .beacon: return DefaultsKeys.isBeaconCommandActive
        case .proximity: return DefaultsKeys.isProximityCommandActive
        case .micLevel: return DefaultsKeys.isMicLevelCommandActive
        case .remoteControl: return DefaultsKeys.isRemoteControlCommandActive
        case .battery: return DefaultsKeys.isBatteryCommandActive
        }
    }

    func isAvailable() -> Bool {
        switch self {
        case .acceleration, .gravity, .gyro, .quaternion:
            return MotionService.shared.isAvailable()
        case .touch:
            return TouchService.shared.isTouchAvailable()
        case .applePencil:
            return TouchService.shared.isApplePencilAvailable()
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
            return isCameraAvailable() && ArkitService.shared.isARKitAvailable()
        case .remoteControl:
            return RemoteControlService.shared.isAvailable()
        case .ndi:
            return isCameraAvailable() && VideoCaptureService.shared.isNDIAvailable()
        case .imageDetection:
            return isCameraAvailable() && VideoCaptureService.shared.isImageDetectionAvailable()
        case .nfc:
            return NFCService.shared.isAvailable()
        }
    }

    func start() {
        switch self {
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

    func stop() {
        switch self {
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

    private func isCameraAvailable() -> Bool {
        !AppSettingModel.shared.isCameraUsed(exceptBy: self)
    }
}
