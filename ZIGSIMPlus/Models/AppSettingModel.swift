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
    case one = 1
    case ten = 10
    case thirty = 30
    case sixty = 60
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

        address = Defaults[.userIpAdress]
        port = Defaults[.userPortNumber]
        deviceUUID = Defaults[.userDeviceUUID]
        beaconUUID = Defaults[.userBeaconUUID]
        dataDestination = Defaults[.userDataDestination]
        transportProtocol = Defaults[.userProtocol]
        transportFormat = Defaults[.userMessageFormat]
        messageRatePerSecondSegment = Defaults[.userMessageRatePerSecond]
        compassOrientation = Defaults[.userCompassOrientation]
        ndiType = Defaults[.userNdiType]
        ndiCameraPosition = Defaults[.userNdiCameraType]
        depthType = Defaults[.userDepthType]
        ndiResolution = Defaults[.userNdiResolution]
        ndiAudioEnabled = Defaults[.userNdiAudioEnabled]
        ndiAudioBufferSize = Defaults[.userNdiAudioBufferSize]
        arkitTrackingType = Defaults[.userArkitTrackingType]
    }

    static let shared = AppSettingModel()
    var isActiveByCommand: Dictionary<Command, Bool> = [:]

    // app default value & variable used in app
    var dataDestination: DataDestination = .OTHER_APP
    var transportProtocol: TransportProtocol = .UDP
    var address: String = "172.17.1.20"
    var port: Int = 3333
    var transportFormat: TransportFormat = .OSC
    var messageRatePerSecondSegment: Int = 3
    var deviceUUID: String = Utils.randomStringWithLength(16)
    var compassOrientation: CompassOrientation = .faceup
    var beaconUUID = "B9407F30-F5F8-466E-AFF9-25556B570000"
    var messageRatePerSecond: RatePerSecond {
        if messageRatePerSecondSegment == 0 {
            return .one
        } else if messageRatePerSecondSegment == 1 {
            return .ten
        } else if messageRatePerSecondSegment == 2 {
            return .thirty
        } else if messageRatePerSecondSegment == 3 {
            return .sixty
        } else {
            fatalError("Unexpected message rate")
        }
    }
    var messageInterval: TimeInterval {
        return 1.0 / Double(messageRatePerSecond.rawValue)
    }
    var imageDetectorType: ImageDetectorType = .face
    var imageDetectorAccuracy: ImageDetectorAccuracy = .high
    var imageDetectorTracks: Bool = false
    var imageDetectorNumberOfAnglesForSegment: ImageDetectorNumberOfAnglesForSegment = .one
    var imageDetectorDetectsEyeBlink: Bool = true
    var imageDetectorDetectsSmile: Bool = true
    var ndiType: NdiType = .CAMERA
    var ndiCameraPosition: NdiCameraPosition = .BACK
    var depthType: DepthType = .DEPTH
    var ndiResolution: NdiResolution = .vga
    var ndiAudioEnabled: NdiAudioEnabled = .enabled
    var ndiAudioBufferSize: NdiAudioBufferSize = .large
    var arkitTrackingType: ArkitTrackingType = .device

    public func getSettingsForOutput() -> [(String, String)] {
        let dst = dataDestination == .OTHER_APP ? "OTHER APP" : "LOCAL FILE"
        let prot = transportProtocol == .TCP ? "TCP" : "UDP"
        let format = transportFormat == .OSC ? "OSC" : "JSON"

        return [
            ("DATA DESTINATION", dst),
            ("PROTOCOL", prot),
            ("IP ADDRESS", address),
            ("PORT", String(port)),
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
    static let userDataDestination = DefaultsKey<DataDestination>("userDataDestination", defaultValue: .OTHER_APP)
    static let userProtocol = DefaultsKey<TransportProtocol>("userProtocol", defaultValue: .UDP)
    static let userIpAdress = DefaultsKey<String>("userIpAdress", defaultValue: "172.17.1.20")
    static let userPortNumber = DefaultsKey<Int>("userPortNumber", defaultValue: 3333)
    static let userMessageFormat = DefaultsKey<TransportFormat>("userMessageFormat", defaultValue: .OSC)
    static let userMessageRatePerSecond = DefaultsKey<Int>("userMessageRatePerSecond", defaultValue: 1)
    static let userCompassOrientation = DefaultsKey<CompassOrientation>("userCompassOrientation", defaultValue: .portrait)
    static let userDeviceUUID = DefaultsKey<String>("userDeviceUUID", defaultValue: Utils.randomStringWithLength(16))
    static let userBeaconUUID = DefaultsKey<String>("userBeaconUUID", defaultValue: "B9407F30-F5F8-466E-AFF9-25556B570000")
    static let userNdiType = DefaultsKey<NdiType>("userNdiType", defaultValue: .CAMERA)
    static let userNdiCameraType = DefaultsKey<NdiCameraPosition>("userNdiCameraType", defaultValue: .BACK)
    static let userDepthType = DefaultsKey<DepthType>("userDepthType", defaultValue: .DEPTH)
    static let userNdiResolution = DefaultsKey<NdiResolution>("userNdiResolution", defaultValue: .vga)
    static let userNdiAudioEnabled = DefaultsKey<NdiAudioEnabled>("userNdiAudioEnabled", defaultValue: .enabled)
    static let userNdiAudioBufferSize = DefaultsKey<NdiAudioBufferSize>("userNdiAudioBufferSize", defaultValue: .large)
    static let userArkitTrackingType = DefaultsKey<ArkitTrackingType>("userArkitTrackingType", defaultValue: .device)
    static let userImageDetectorType = DefaultsKey<ImageDetectorType>("userArkitTrackingType", defaultValue: .face)
    static let userImageDetectorAccuracy = DefaultsKey<ImageDetectorAccuracy>("userImageDetectorAccuracy", defaultValue: .high)
    static let userImageDetectorTracks = DefaultsKey<Bool>("userImageDetectorTracks", defaultValue: true)
    static let userImageDetectorNumberOfAnglesForSegment = DefaultsKey<ImageDetectorNumberOfAnglesForSegment>("userImageDetectorNumberOfAnglesForSegment", defaultValue: .one)
    static let userImageDetectorDetectsEyeBlink = DefaultsKey<Bool>("userImageDetectorDetectsEyeBlink", defaultValue: true)
    static let userImageDetectorDetectsSmile = DefaultsKey<Bool>("userImageDetectorDetectsSmile", defaultValue: true)

    // Commands
    static let userNdiCommand = DefaultsKey<Bool>("userNdiCommand", defaultValue: false)
    static let userArkitCommand = DefaultsKey<Bool>("userArkitCommand", defaultValue: false)
    static let userImageDetectionCommand = DefaultsKey<Bool>("userImageDetectionCommand", defaultValue: false)
    static let userNfcReaderCommand = DefaultsKey<Bool>("userNfcReaderCommand", defaultValue: false)
    static let userApplePencilCommand = DefaultsKey<Bool>("userApplePencilCommand", defaultValue: false)
    static let userAccelerationCommand = DefaultsKey<Bool>("userAccelerationCommand", defaultValue: false)
    static let userGravityCommand = DefaultsKey<Bool>("userGravityCommand", defaultValue: false)
    static let userGyroCommand = DefaultsKey<Bool>("userGyroCommand", defaultValue: false)
    static let userQuaternionCommand = DefaultsKey<Bool>("userQuaternionCommand", defaultValue: false)
    static let userCompassCommand = DefaultsKey<Bool>("userCompassCommand", defaultValue: false)
    static let userPressureCommand = DefaultsKey<Bool>("userPressureCommand", defaultValue: false)
    static let userGpsCommand = DefaultsKey<Bool>("userGpsCommand", defaultValue: false)
    static let userTouchCommand = DefaultsKey<Bool>("userTouchCommand", defaultValue: false)
    static let userBeaconCommand = DefaultsKey<Bool>("userBeaconCommand", defaultValue: false)
    static let userProximityCommand = DefaultsKey<Bool>("userProximityCommand", defaultValue: false)
    static let userMicLevelCommand = DefaultsKey<Bool>("userMicLevelCommand", defaultValue: false)
    static let userRemoteControlCommand = DefaultsKey<Bool>("userRemoteControlCommand", defaultValue: false)
    static let userBatteryCommand = DefaultsKey<Bool>("userBatteryCommand", defaultValue: false)
}
