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
    case ndi = "NDI"
    case nfc = "NFC READER"
    case arkit = "ARKit"
    case faceTracking = "Face Tracking"
    case battery = "Battery"
    case applePencil = "Apple Pencil"
}

/// NOTE: the order of cases affects selection view.
let commandsNumber:[Int: Command] = [
    0: Command.acceleration,
    1: Command.gravity,
    2: Command.gyro,
    3: Command.quaternion,
    4: Command.compass,
    5: Command.pressure,
    6: Command.gps,
    7: Command.touch,
    8: Command.beacon,
    9: Command.proximity,
    10: Command.micLevel,
    11: Command.remoteControl,
    12: Command.ndi,
    13: Command.nfc,
    14: Command.arkit,
    15: Command.faceTracking,
    16: Command.battery,
    17: Command.applePencil
]
