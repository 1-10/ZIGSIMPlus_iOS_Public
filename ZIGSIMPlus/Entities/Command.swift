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
        case .ndi: return .isNdiCommandActive
        case .arkit: return .isArkitCommandActive
        case .imageDetection: return .isImageDetectionCommandActive
        case .nfc: return .isNfcReaderCommandActive
        case .applePencil: return .isApplePencilCommandActive
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

    var isPremium: Bool {
        switch self {
        case .ndi, .arkit, .imageDetection, .nfc, .applePencil:
            return true
        default:
            return false
        }
    }
}
