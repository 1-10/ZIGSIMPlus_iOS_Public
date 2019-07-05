//
//  Command.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

/// Command is a constant label corresponds to features.
/// NOTE: the order of cases affects selection view.
public enum Command: String, CaseIterable {
    case ndi = "NDI"
    case arkit = "ARKit"
    case imageDetection = "IMAGE DETECTION"
    case nfc = "NFC READER"
    case applePencil = "Apple Pencil"
    case acceleration = "Acceleration"
    case gravity = "Gravity"
    case gyro = "Gyro"
    case quaternion = "Quaternion"
    case compass = "Compass"
    case pressure = "Pressure"
    case gps = "Gps"
    case touch = "Touch"
    case beacon = "Beacon"
    case proximity = "Proximity"
    case micLevel = "MIC LEVEL"
    case remoteControl = "Remote Control"
    case battery = "Battery"
    
    var userDefaultsKey: DefaultsKey<Bool> {
        switch self {
        case .ndi: return DefaultsKeys.userNdiCommand
        case .arkit: return DefaultsKeys.userArkitCommand
        case .imageDetection: return DefaultsKeys.userImageDetectionCommand
        case .nfc: return DefaultsKeys.userNfcReaderCommand
        case .applePencil: return DefaultsKeys.userApplePencilCommand
        case .acceleration: return DefaultsKeys.userAccelerationCommand
        case .gravity: return DefaultsKeys.userGravityCommand
        case .gyro: return DefaultsKeys.userGyroCommand
        case .quaternion: return DefaultsKeys.userQuaternionCommand
        case .compass: return DefaultsKeys.userCompassCommand
        case .pressure: return DefaultsKeys.userPressureCommand
        case .gps: return DefaultsKeys.userGpsCommand
        case .touch: return DefaultsKeys.userTouchCommand
        case .beacon: return DefaultsKeys.userBeaconCommand
        case .proximity: return DefaultsKeys.userProximityCommand
        case .micLevel: return DefaultsKeys.userMicLevelCommand
        case .remoteControl: return DefaultsKeys.userRemoteControlCommand
        case .battery: return DefaultsKeys.userBatteryCommand
        }
    }
}
