//
//  LabelConstants.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

// NOTE: the order of cases affects selection view
public enum Label: String, CaseIterable {
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
    case arkit = "ARKit"
    case faceTracking = "Face Tracking"
    case battery = "Battery"
    case applePencil = "Apple Pencil"
}
