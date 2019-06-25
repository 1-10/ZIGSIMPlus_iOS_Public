//
//  ModalTexts.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/10.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

// Title and Body for help modal
let modalTexts:[Command: (title: String, body: String)] = [
    .acceleration : ("Acceleration", "test0\naccelerationです。"),
    .gravity : ("Gravity", "test1\ngravityです。"),
    .gyro : ("Gyro", "test2\ngyroです。"),
    .quaternion : ("Quaternion", "test3\nquaternionです。"),
    .compass : ("Compass", "test4\ncompassです。"),
    .pressure: ("Pressure", "test5\npressureです。"),
    .gps : ("GPS", "test6\ngpsです。"),
    .touch : ("Touch", "test7\ntouchです。"),
    .beacon : ("Beacon", "test8\nbeaconです。"),
    .proximity : ("Proximity", "test9\nproximityです。"),
    .micLevel : ("Mic Level", "test10\nmicLevelです。"),
    .remoteControl : ("Remote Control", "test11\nremoteControlです。"),
    .ndi : ("NDI™", "test12\nndiです。"),
    .nfc : ("NFC", "test13\nnfcです。"),
    .arkit : ("ARKit", "test14\narkitです。"),
    .battery : ("Battery", "test16\nbatteryです。"),
    .applePencil : ("Apple Pencil", "test17\napplePencilです。"),
]
