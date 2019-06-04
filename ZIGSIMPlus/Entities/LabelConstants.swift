//
//  LabelConstants.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public enum Label: String {
    case acceleration = "Acceleration"
    case gravity = "Gravity"
    case gyro = "Gyro"
    case quaternion = "Quaternion"
    case touch = "Touch"
    case compass = "Compass"
    case pressure = "Pressure"
    case gps = "Gps"
    case beacon = "Beacon"
    case proximity = "Proximity"
    case micLevel = "MIC LEVEL"
    case battery = "Battery"
    case arkit = "ARKit"
    case faceTracking = "Face Tracking"
    case remoteControl = "Remote Control"
    case ndi = "NDI"
    case nfc = "NFC READER"
    case applePencil = "Apple Pencil"
}

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
    Label.arkit,
    Label.faceTracking,
    Label.remoteControl,
    Label.ndi,
    Label.nfc,
    Label.applePencil
]
