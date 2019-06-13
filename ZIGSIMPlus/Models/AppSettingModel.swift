//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

enum DataDestination: Int {
    case LOCAL_FILE = 0
    case OTHER_APP = 1
}

enum TransportProtocol: Int {
    case UDP = 0
    case TCP = 1
}

enum TransportFormat: Int {
    case JSON = 0
    case OSC = 1
}

enum RatePerSecond: Int {
    case one = 1
    case ten = 10
    case thirty = 30
    case sixty = 60
}

enum ImageDetectorType: Int {
    case face = 1
    case qrCode = 2
    case rectangle = 3
    case text = 4
}

enum ImageDetectorAccuracy: Int {
    case low = 1
    case high = 2
}

enum ImageDatectorNumberOfAngles: Int {
    case one = 1
    case three = 3
    case five = 5
    case seven = 7
    case nine = 9
    case eleven = 11
}
    
enum NdiType: Int {
    case CAMERA = 0
    case DEPTH = 1
}

enum NdiCameraType: Int {
    case BACK = 0
    case FRONT = 1
}

enum DepthType: Int {
    case DEPTH = 0
    case DISPARITY = 1
}

public class AppSettingModel {
    private init() {
        for command in Command.allCases {
            isActiveByCommand[command] = false
        }
        
        address = Defaults[.userIpAdress]?.description ?? ""
        port = Int32(Defaults[.userPortNumber]?.description ?? "") ?? 0
        deviceUUID = Defaults[.userDeviceUUID]?.description ?? ""
        beaconUUID = Defaults[.userBeaconUUID]?.description ?? ""
        dataDestination = DataDestination(rawValue: Defaults[.userDataDestination] ?? 0)!
        transportProtocol = TransportProtocol(rawValue: Defaults[.userProtocol] ?? 0)!
        transportFormat = TransportFormat(rawValue: Defaults[.userMessageFormat] ?? 0)!
        messageRatePerSecondSegment = Defaults[.userMessageRatePerSecond] ?? 0
        faceup = Defaults[.userCompassAngle] ?? 0
        ndiType = NdiType(rawValue: Defaults[.userNdiType] ?? 0)!
        ndiCameraType = NdiCameraType(rawValue: Defaults[.userNdiCameraType] ?? 0)!
        depthType = DepthType(rawValue: Defaults[.userDepthType] ?? 0)!
    }
    
    static let shared = AppSettingModel()
    var isActiveByCommand: Dictionary<Command, Bool> = [:]
    
    // app default value & variable used in app
    var dataDestination: DataDestination = .OTHER_APP
    var transportProtocol: TransportProtocol = .UDP
    var address: String = "172.17.1.20"
    var port: Int32 = 3333
    var transportFormat: TransportFormat = .OSC
    var messageRatePerSecondSegment: Int = 3
    var deviceUUID: String = Utils.randomStringWithLength(16)
    var faceup: Int = 1 // 1.0 is faceup
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
    var compassAngle: Double {
        return Double(faceup)
    }
    var imageDetectorType: ImageDetectorType = .face
    var imageDetectorAccuracy: ImageDetectorAccuracy = .high
    var imageDetectorTracks: Bool = false
    var imageDetectorNumberOfAngles: ImageDatectorNumberOfAngles = .one
    var imageDetectorDetectEyeBlink: Bool = true
    var imageDetectorDetectSmile: Bool = true
    var ndiType: NdiType = .CAMERA
    var ndiCameraType: NdiCameraType = .BACK
    var depthType: DepthType = .DEPTH

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
}

// user default value
extension DefaultsKeys {
    static let userDataDestination = DefaultsKey<Int?>("userDataDestination", defaultValue: 1)
    static let userProtocol = DefaultsKey<Int?>("userProtocol", defaultValue: 0)
    static let userIpAdress = DefaultsKey<String?>("userIpAdress", defaultValue: "172.17.1.20")
    static let userPortNumber = DefaultsKey<Int?>("userPortNumber", defaultValue: 3333)
    static let userMessageFormat = DefaultsKey<Int?>("userMessageFormat", defaultValue: 1)
    static let userMessageRatePerSecond = DefaultsKey<Int?>("userMessageRatePerSecond", defaultValue: 3)
    static let userCompassAngle = DefaultsKey<Int?>("userCompassAngle", defaultValue: 1)
    static let userDeviceUUID = DefaultsKey<String?>("userDeviceUUID", defaultValue: Utils.randomStringWithLength(16))
    static let userBeaconUUID = DefaultsKey<String?>("userBeaconUUID", defaultValue: "B9407F30-F5F8-466E-AFF9-25556B570000")
    static let userNdiType = DefaultsKey<Int?>("userNdiType", defaultValue: 0)
    static let userNdiCameraType = DefaultsKey<Int?>("userNdiCameraType", defaultValue: 0)
    static let userDepthType = DefaultsKey<Int?>("userDepthType", defaultValue: 0)
}
