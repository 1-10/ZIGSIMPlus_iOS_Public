//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum DataDestination: Int, DefaultsSerializable {
    case LOCAL_FILE = 0
    case OTHER_APP = 1
}

enum TransportProtocol: Int, DefaultsSerializable {
    case UDP = 0
    case TCP = 1
}

enum TransportFormat: Int, DefaultsSerializable {
    case JSON = 0
    case OSC = 1
}

enum RatePerSecond: Int, DefaultsSerializable {
    case one = 0
    case ten = 1
    case thirty = 2
    case sixty = 3
}

enum ImageDetectorType: Int, DefaultsSerializable {
    case face = 0
    case qrCode = 1
    case rectangle = 2
    case text = 3
}

enum ImageDetectorAccuracy: Int, DefaultsSerializable {
    case low = 0
    case high = 1
}

enum ImageDetectorNumberOfAngles: Int, DefaultsSerializable {
    case one = 1
    case three = 3
    case five = 5
    case seven = 7
    case nine = 9
    case eleven = 11
}

enum ImageDetectorNumberOfAnglesForSegment: Int, DefaultsSerializable {
    case one = 0
    case three = 1
    case five = 2
    case seven = 3
    case nine = 4
    case eleven = 5
}

enum ArkitTrackingType: Int, DefaultsSerializable {
    case device = 0
    case face = 1
    case image = 2
}

enum NdiType: Int, DefaultsSerializable {
    case CAMERA = 0
    case DEPTH = 1
}

enum NdiCameraPosition: Int, DefaultsSerializable {
    case BACK = 0
    case FRONT = 1
}

enum DepthType: Int, DefaultsSerializable {
    case DEPTH = 0
    case DISPARITY = 1
}

enum NdiResolution: Int, DefaultsSerializable {
    case vga = 0
    case hd = 1
    case fhd = 2
}

enum NdiAudioEnabled: Int, DefaultsSerializable {
    case enabled = 0
    case disabled = 1
}

enum NdiAudioBufferSize: Int, DefaultsSerializable {
    case small = 0
    case medium = 1
    case large = 2
}

enum CompassOrientation: Int, DefaultsSerializable {
    case portrait = 0
    case faceup = 1
}

enum SettingViewTextType {
    case ipAddress
    case portNumber
    case deviceUuid
}

public class AppSettingModel {
    private init() {
        for command in Command.allCases {
            isActiveByCommand[command] = false
        }
    }
    static let shared = AppSettingModel()
    var isActiveByCommand: Dictionary<Command, Bool> = [:]

    // app default value & variable used in app
    var address = Defaults[.ipAdress]
    var port = Defaults[.portNumber]
    var deviceUUID = Defaults[.deviceUUID]
    var beaconUUID = Defaults[.beaconUUID]
    var dataDestination = Defaults[.dataDestination]
    var transportProtocol = Defaults[.transportProtocol]
    var transportFormat = Defaults[.transportFormat]
    var messageRatePerSecond = Defaults[.messageRatePerSecond]
    var compassOrientation = Defaults[.compassOrientation]
    var ndiType = Defaults[.ndiType]
    var ndiCameraPosition = Defaults[.ndiCameraType]
    var depthType = Defaults[.depthType]
    var ndiResolution = Defaults[.ndiResolution]
    var ndiAudioEnabled = Defaults[.ndiAudioEnabled]
    var ndiAudioBufferSize = Defaults[.ndiAudioBufferSize]
    var arkitTrackingType = Defaults[.arkitTrackingType]
    var imageDetectorType = Defaults[.imageDetectorType]
    var imageDetectorAccuracy = Defaults[.imageDetectorAccuracy]
    var imageDetectorTracks = Defaults[.imageDetectorTracks]
    var imageDetectorNumberOfAnglesForSegment = Defaults[.imageDetectorNumberOfAnglesForSegment]
    var imageDetectorDetectsEyeBlink = Defaults[.imageDetectorDetectsEyeBlink]
    var imageDetectorDetectsSmile = Defaults[.imageDetectorDetectsSmile]

    public func getSettingsForOutput() -> [(String, String)] {
        let dst = dataDestination == .OTHER_APP ? "OTHER APP" : "LOCAL FILE"
        let prot = transportProtocol == .TCP ? "TCP" : "UDP"
        let format = transportFormat == .OSC ? "OSC" : "JSON"

        return [
            ("DATA DESTINATION", dst),
            ("PROTOCOL", prot),
            ("IP ADDRESS", ipAddress),
            ("PORT", String(portNumber)),
            ("MESSAGE FORMAT", format),
            ("DEVICE UUID", deviceUUID),
        ]
    }

    public func isCameraUsed(exceptBy command: Command? = nil) -> Bool {
        var isCameraUsed = false
        if command != .arkit {
            isCameraUsed = (isCameraUsed || isActiveByCommand[.arkit]!)
        }
        if command != .ndi {
            isCameraUsed = (isCameraUsed || isActiveByCommand[.ndi]!)
        }
        if command != .imageDetection {
            isCameraUsed = (isCameraUsed || isActiveByCommand[.imageDetection]!)
        }

        return isCameraUsed
    }

    public func isTouchEnabled() -> Bool {
        return AppSettingModel.shared.isActiveByCommand[.touch]! ||
            AppSettingModel.shared.isActiveByCommand[.applePencil]!
    }
    
    var imageDetectorNumberOfAngles: ImageDetectorNumberOfAngles {
        switch imageDetectorNumberOfAnglesForSegment {
        case .one:
            return .one
        case .three:
            return .three
        case .five:
            return .five
        case .seven:
            return .seven
        case .nine:
            return .nine
        case .eleven:
            return .eleven
        }
    }
}

// user default value
extension DefaultsKeys {
    // Settings
    static let dataDestination = DefaultsKey<DataDestination>("dataDestination", defaultValue: .OTHER_APP)
    static let transportProtocol = DefaultsKey<TransportProtocol>("transportProtocol", defaultValue: .UDP)
    static let ipAddress = DefaultsKey<String>("ipAddress", defaultValue: "172.17.1.20")
    static let portNumber = DefaultsKey<Int>("portNumber", defaultValue: 3333)
    static let transportFormat = DefaultsKey<TransportFormat>("messageFormat", defaultValue: .OSC)
    static let messageRatePerSecond = DefaultsKey<RatePerSecond>("messageRatePerSecond", defaultValue: .ten)
    static let compassOrientation = DefaultsKey<CompassOrientation>("compassOrientation", defaultValue: .portrait)
    static let deviceUUID = DefaultsKey<String>("deviceUUID", defaultValue: Utils.randomStringWithLength(16))
    static let beaconUUID = DefaultsKey<String>("beaconUUID", defaultValue: "B9407F30-F5F8-466E-AFF9-25556B570000")
    static let ndiType = DefaultsKey<NdiType>("ndiType", defaultValue: .CAMERA)
    static let ndiCameraPosition = DefaultsKey<NdiCameraPosition>("ndiCameraPosition", defaultValue: .BACK)
    static let depthType = DefaultsKey<DepthType>("depthType", defaultValue: .DEPTH)
    static let ndiResolution = DefaultsKey<NdiResolution>("ndiResolution", defaultValue: .vga)
    static let ndiAudioEnabled = DefaultsKey<NdiAudioEnabled>("ndiAudioEnabled", defaultValue: .enabled)
    static let ndiAudioBufferSize = DefaultsKey<NdiAudioBufferSize>("ndiAudioBufferSize", defaultValue: .large)
    static let arkitTrackingType = DefaultsKey<ArkitTrackingType>("arkitTrackingType", defaultValue: .device)
    static let imageDetectorType = DefaultsKey<ImageDetectorType>("imageDetectorType", defaultValue: .face)
    static let imageDetectorAccuracy = DefaultsKey<ImageDetectorAccuracy>("imageDetectorAccuracy", defaultValue: .high)
    static let imageDetectorTracks = DefaultsKey<Bool>("imageDetectorTracks", defaultValue: true)
    static let imageDetectorNumberOfAnglesForSegment = DefaultsKey<ImageDetectorNumberOfAnglesForSegment>("imageDetectorNumberOfAnglesForSegment", defaultValue: .one)
    static let imageDetectorDetectsEyeBlink = DefaultsKey<Bool>("imageDetectorDetectsEyeBlink", defaultValue: true)
    static let imageDetectorDetectsSmile = DefaultsKey<Bool>("imageDetectorDetectsSmile", defaultValue: true)

    // Commands
    static let isNdiCommandActive = DefaultsKey<Bool>("isNdiCommandActive", defaultValue: false)
    static let isArkitCommandActive = DefaultsKey<Bool>("isArkitCommandActive", defaultValue: false)
    static let isImageDetectionCommandActive = DefaultsKey<Bool>("isImageDetectionCommandActive", defaultValue: false)
    static let isNfcReaderCommandActive = DefaultsKey<Bool>("isNfcReaderCommandActive", defaultValue: false)
    static let isApplePencilCommandActive = DefaultsKey<Bool>("isApplePencilCommandActive", defaultValue: false)
    static let isAccelerationCommandActive = DefaultsKey<Bool>("isAccelerationCommandActive", defaultValue: false)
    static let isGravityCommandActive = DefaultsKey<Bool>("isGravityCommandActive", defaultValue: false)
    static let isGyroCommandActive = DefaultsKey<Bool>("isGyroCommandActive", defaultValue: false)
    static let isQuaternionCommandActive = DefaultsKey<Bool>("isQuaternionCommandActive", defaultValue: false)
    static let isCompassCommandActive = DefaultsKey<Bool>("isCompassCommandActive", defaultValue: false)
    static let isPressureCommandActive = DefaultsKey<Bool>("isPressureCommandActive", defaultValue: false)
    static let isGpsCommandActive = DefaultsKey<Bool>("isGpsCommandActive", defaultValue: false)
    static let isTouchCommandActive = DefaultsKey<Bool>("isTouchCommandActive", defaultValue: false)
    static let isBeaconCommandActive = DefaultsKey<Bool>("isBeaconCommandActive", defaultValue: false)
    static let isProximityCommandActive = DefaultsKey<Bool>("isProximityCommandActive", defaultValue: false)
    static let isMicLevelCommandActive = DefaultsKey<Bool>("isMicLevelCommandActive", defaultValue: false)
    static let isRemoteControlCommandActive = DefaultsKey<Bool>("isRemoteControlCommandActive", defaultValue: false)
    static let isBatteryCommandActive = DefaultsKey<Bool>("isBatteryCommandActive", defaultValue: false)
}

