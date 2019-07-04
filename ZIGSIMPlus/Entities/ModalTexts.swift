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
    .compass : ("Compass", """
Compass command detects azimuth angle.

Users can switch the orientation of device in detail settings:
**PORTRAIT**:The device is held upright and the home button at the bottom.
**FACEUP** :The device is held parallel to the ground with the screen facing upwards.
"""),
    .pressure: ("Pressure", """
Pressure command detects altitude events and outputs following values:
Pressure[hPa]
Altitude[meter]
"""),
    .gps : ("GPS", """
GPS command detects GPS signal and outputs **latitude** and **longitude**.
"""),
    .touch : ("Touch", """
Touch command detects touch events in Start tab and outputs following values:
**Position** is the relative position of touches from the center of the screen.
**Radius** is the radius of touch event in pixel size.
**Force** is the force of 3D Touch.
"""),
    .beacon : ("Beacon", """
Beacon command detects iBeacons around the device and outputs following values:
**BeaconUUID**, **Major** and **Minor** are used to identify the beacon.
**RSSI** is the strength of the signal from the beacon.
"""),
    .proximity : ("Proximity", """
Proximity command detects whether the proximity sensor is close to the user (true) or not (false).
"""),
    .micLevel : ("Mic Level", """
Mic Level command detects sound level around the device and outputs following values:
**max**: Peak RMS power of the mic input.
**average**: Average RMS power of the mic input.
Max value is 0.
"""),
    .remoteControl : ("Remote Control", """
Remote Control command monitors the state of remote controllers of headphones connected to the device.
*playpause*, *volumeUp* and *volumeDown* shows the buttons are pressed or not.
*isPlaying* and *volume* shows the device state changed by controllers.
"""),
    .ndi : ("NDI™", """
NDI command transmits images from the device via NDI protocol.
This command has following settings:

## IMAGE TYPE
**CAMERA**: send images captured by camera.
**DEPTH**: send depth maps captured by camera.

## CAMERA
Toggle camera between **REAR** and **FRONT**.

## DEPTH TYPE
**DEPTH**: capture depth map.
**DISPARITY**: capture disparity map.

## RESOLUTION
Set NDI video resolution to **VGA**, **HD** or **FHD**.

## AUDIO LATENCY
Set NDI audio latency **LOW**, **MEDIUM** or **HIGH** by changing the buffer size.
Lower latency may cause audio glitch due to small buffer.

NDI™ is a trademark of NewTek, Inc.
For more detail of NDI, See http://NDI.NewTek.com/
"""),
    .nfc : ("NFC", "test13\nnfcです。"),
    .arkit : ("ARKit", """
ARKit command tracks different objects for the tracking type.

**DEVICE**: device position, device rotation, feature points' positions.
**FACE**: device rotation, face position, face rotation, eye position.
**MARKER**: device rotation, marker position, marker rotation.
"""),
    .battery : ("Battery", "test16\nbatteryです。"),
    .applePencil : ("Apple Pencil", "test17\napplePencilです。"),
]
