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
    case depth = "DEPTH"
}
<<<<<<< HEAD:ZIGSIMPlus/Entities/LabelConstants.swift

public let CommandDataLabels = [
    Label.acceleration,
    Label.gravity,
    Label.gyro,
    Label.quaternion,
    Label.touch,
    Label.compass,
    Label.pressure,
    Label.gps,
    Label.beacon,
    Label.proximity,
    Label.micLevel,
    Label.battery,
    Label.remoteControl,
    Label.ndi,
    Label.applePencil,
    Label.depth
]
=======
>>>>>>> master:ZIGSIMPlus/Entities/Command.swift
