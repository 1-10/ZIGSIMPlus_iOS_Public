//
//  ModalTexts.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/10.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

// swiftlint:disable line_length

// Title and Body for help modal
let modalTexts: [Command: (title: String, body: String)] = [
    .acceleration: ("Acceleration", """
    Acceleration command detects acceleration that the user is giving to the device.
    Values are in G's (gravitational force) for X, Y and Z axis.
    """),
    .gravity: ("Gravity", """
    Gravity command detects gravity acceleration vector expressed in the device's reference frame.
    Values are in G's (gravitational force) for X, Y and Z axis.
    """),
    .gyro: ("Gyro", """
    Gyro command detects rotation rate of the device.
    Values contain a measurement of gyroscope data whose bias has been removed by Core Motion algorithms.
    Values are in radians per second around X, Y and Z axis.
    """),
    .quaternion: ("Quaternion", """
    Quaternion command detects attitude of the device, that is, the orientation of a body relative to a given frame of reference.
    Values are quaternion for X, Y, Z and W axis.
    """),
    .compass: ("Compass", """
    Compass command detects azimuth angle and outputs following values:
    **Compass**:Azimuth angle. North is 0 degrees, east is 90 degrees, south is 180 degrees, and so on. A negative value indicates an invalid direction.
    **Orientation**:Orientation of device. This can be set in the detail settings.

    Users can switch the orientation of device in detail settings:
    **PORTRAIT**:The device is held upright and the home button at the bottom.
    **FACEUP** :The device is held parallel to the ground with the screen facing upwards.
    """),
    .pressure: ("Pressure", """
    Pressure command detects altitude events and outputs following values:
    **pressure** [hPa]
    **altitude** [meter]
    """),
    .gps: ("GPS", """
    GPS command detects GPS signal and outputs **latitude** and **longitude**.
    """),
    .touch: ("Touch", """
    Touch command detects touch events in Start tab and outputs following values:
    **Position** is the relative position of touches from the center of the screen.
    **Radius** is the radius of touch event in pixel size.
    **Force** is the force of 3D Touch, where a value of 1.0 represents the force of an average touch.
    """),
    .beacon: ("Beacon", """
    Beacon command detects iBeacons around the device and outputs following values:
    **BeaconUUID**, **Major** and **Minor** are used to identify the beacon.
    **RSSI** is the strength of the signal from the beacon.
    """),
    .proximity: ("Proximity", """
    Proximity command detects whether the proximity sensor is close to the user (true) or not (false).
    """),
    .micLevel: ("Mic Level", """
    Mic Level command detects sound level around the device and outputs following values:
    **max**: Peak RMS power of the mic input.
    **average**: Average RMS power of the mic input.
    Max value is 0.
    """),
    .remoteControl: ("Remote Control", """
    Remote Control command monitors the state of remote controllers of headphones connected to the device.
    *playpause*, *volumeUp* and *volumeDown* shows the buttons are pressed or not.
    *isPlaying* and *volume* shows the device state changed by controllers.
    """),
    .ndi: ("NDI™", """
    NDI command transmits images from the device via NDI protocol.
    You cannot use NDI, ARKit and Image Detection simultaneously.
    This command has following settings:

    ## Image Type
    **CAMERA**: send images captured by camera.
    **DEPTH**: send depth maps captured by camera.
    **BOTH**: send camera images in RGB channel and depth maps in alpha channel.

    ## Camera
    Toggle camera between **REAR** and **FRONT**.

    ## Depth Type
    **DEPTH**: capture depth map.
    **DISPARITY**: capture disparity map.

    ## Resolution
    Set NDI video resolution to **VGA**, **HD** or **FHD**.

    ## Audio Latency
    Set NDI audio latency **LOW**, **MEDIUM** or **HIGH** by changing the buffer size.
    Lower latency may cause audio glitch due to small buffer.

    NDI™ is a trademark of NewTek, Inc.
    For more detail of NDI, See http://NDI.NewTek.com/
    """),
    .nfc: ("NFC Reader", """
    NFC Reader command detects NFC tags and read messages that contain NDEF data.
    Output values are defined by the NDEF specification.

    **id**: The identifier of the payload.
    **data**: Data of the payload. Trimming header for the first several bytes is not supported.
    **typenameformat**: Type Name Format field of the payload.
    **type**: Type of the payload.
    """),
    .arkit: ("ARKit", """
    ARKit command tracks different objects for the tracking type.
    You cannot use NDI, ARKit and Image Detection simultaneously.

    **DEVICE**: device position, device rotation, feature points' positions.
    **FACE**: device rotation, face position, face rotation, eye position.
    **MARKER**: device rotation, marker position, marker rotation.

    If **Feature Points** is *ON*, the position of feature points will be output.
    """),
    .battery: ("Battery", """
    Battery command monitors the battery charge level of the device.
    It ranges from 0.0 (fully discharged) to 1.0 (100% charged).
    Note that this value may be inaccurate.
    """),
    .applePencil: ("Apple Pencil", """
    Apple Pencil command detects touch events in Start tab (same as Touch command).
    Note that it only works on Apple Pencil compatible devices, that are some of iPad models.

    **touch**: Relative position of touches from the center of the screen.
    **altitude**: The altitude (in radians) of the stylus. A value of 0 indicates that the stylus is parallel to the surface. The value is Pi/2 when the stylus is perpendicular to the surface.
    **azimuth**: The azimuth angle (in radians) of the stylus. In the plane of the screen, the azimuth angle is the direction in which the stylus is pointing. It increases as the user swings the cap end of the stylus in a clockwise direction around the tip.
    **force**: The force of 3D Touch, where a value of 1.0 represents the force of an average touch.
    """),
    .imageDetection: ("Image Detection", """
    Image Detection command identifies notable features (such as faces and barcodes) from a camera.
    Max frame rate is 30fps, so if you set 60fps it works on 30fps. Note that at the higher the frame rate and resolution, computational cost gets higher. You cannot use NDI, ARKit and Image Detection simultaneously.

    Settings:
    **Detection Type**: Object type to detect, i.e. face, QR code, rectangle and text.
    **Camera**: Which camera to use, REAR or FRONT.
    **Resolution**: Video resolution.
    **Accuracy**: Accuracy of detection. When set high, it requires more processing time.
    **Tracking**: Enable or disable face tracking across frames in the video. Valid only when Detection Type is FACE. When turned ON, line color around detected faces varies depending on tracking IDs.
    **Number of Face Angles**: The number of perspectives to use for detecting a face. At higher numbers of angles, it becomes more accurate, but at a higher computational cost. Valid only when Detection Type is FACE.
    **Detect Eye Blink**: Whether to perform additional processing to recognize closed eyes in detected faces. Valid only when Detection Type is FACE.
    **Detect Smile**: Whether to perform additional processing to recognize smiles in detected faces. Valid only when Detection Type is FACE.

    Output values for Detection Type FACE:
    **left:x, right:x, top:y, bottom:y, lefteye, righteye, mouth**: Coordinate(point) in the video frame. Bottom left is (0, 0), top right is determined by the dimension of the video.
    **hassmile, lefteye-closed, righteye-closed**: True or false.
    **faceangle**: The rotation of the face. Rotation is measured counterclockwise in degrees, with zero indicating that a line drawn between the eyes is horizontal relative to the image orientation.
    **trackingID**: The tracking identifier of the face object. This identifier persists only as long as a face is in the video frame and is not associated with a specific face.

    Output values for others:
    **topleft, topright, bottomleft, bottomright**: Coordinate in the video frame. Bottom left is (0, 0), top right is determined by the dimension of the video.
    **qrmessage, qrversion, qrmaskpattern, qrerrorcorrectionlevel**: Output only when Detection Type is QR.
    """),
]
