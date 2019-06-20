//
//  Command.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

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
}
