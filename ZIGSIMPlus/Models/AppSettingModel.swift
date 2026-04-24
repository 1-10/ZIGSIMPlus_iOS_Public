//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

enum DataDestination: Int {
    case localFile = 0
    case otherApp = 1
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
    case one = 0
    case ten = 1
    case thirty = 2
    case sixty = 3
}

enum ImageDetectorType: Int {
    case face = 0
    case qrCode = 1
    case rectangle = 2
    case text = 3
}

enum ImageDetectorAccuracy: Int {
    case low = 0
    case high = 1
}

enum ImageDetectorNumberOfAngles: Int {
    case one = 0
    case three = 1
    case five = 2
    case seven = 3
    case nine = 4
    case eleven = 5
}

enum ArkitTrackingType: Int {
    case device = 0
    case face = 1
    case image = 2
    case body = 3
}

enum ArkitFeaturePointsEnabled: Int {
    case enabled
    case disabled
}

enum NdiSceneType: Int {
    case WORLD = 0
    case HUMAN = 1
}

enum NdiWorldType: Int {
    case CAMERA = 0
    case DEPTH = 1
    case BOTH = 2
}

enum CameraPosition: Int {
    case BACK = 0
    case FRONT = 1
}

enum DepthType: Int {
    case DEPTH = 0
    case DISPARITY = 1
}

enum NdiHumanType: Int {
    case HUMAN = 0
    case BOTH1 = 1
    case BOTH2 = 2
}

enum VideoResolution: Int {
    case vga = 0
    case hd = 1
    case fhd = 2
}

enum NdiAudioEnabled: Int {
    case enabled = 0
    case disabled = 1
}

enum NdiAudioBufferSize: Int {
    case small = 0
    case medium = 1
    case large = 2
}

enum CompassOrientation: Int {
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

    // MARK: - properties

    var isActiveByCommand: [Command: Bool] = [:]

    // MARK: - Settings properties

    // swiftlint:disable line_length
    var dataDestination: DataDestination {
        get { ud.enumValue(forKey: "dataDestination", default: .otherApp) }
        set { ud.set(newValue.rawValue, forKey: "dataDestination") }
    }

    var transportProtocol: TransportProtocol {
        get { ud.enumValue(forKey: "transportProtocol", default: .UDP) }
        set { ud.set(newValue.rawValue, forKey: "transportProtocol") }
    }

    var ipAddress: String {
        get { ud.string(forKey: "ipAddress") ?? "172.17.1.20" }
        set { ud.set(newValue, forKey: "ipAddress") }
    }

    var portNumber: Int {
        get { ud.object(forKey: "portNumber") != nil ? ud.integer(forKey: "portNumber") : 3333 }
        set { ud.set(newValue, forKey: "portNumber") }
    }

    // Note: UserDefaults key is "messageFormat" (not "transportFormat") for backward compatibility
    var transportFormat: TransportFormat {
        get { ud.enumValue(forKey: "messageFormat", default: .OSC) }
        set { ud.set(newValue.rawValue, forKey: "messageFormat") }
    }

    var messageRatePerSecond: RatePerSecond {
        get { ud.enumValue(forKey: "messageRatePerSecond", default: .ten) }
        set { ud.set(newValue.rawValue, forKey: "messageRatePerSecond") }
    }

    var compassOrientation: CompassOrientation {
        get { ud.enumValue(forKey: "compassOrientation", default: .portrait) }
        set { ud.set(newValue.rawValue, forKey: "compassOrientation") }
    }

    var deviceUUID: String {
        get { ud.string(forKey: "deviceUUID") ?? Utils.randomStringWithLength(16) }
        set { ud.set(newValue, forKey: "deviceUUID") }
    }

    var beaconUUID: String {
        get { ud.string(forKey: "beaconUUID") ?? "B9407F30-F5F8-466E-AFF9-25556B570000" }
        set { ud.set(newValue, forKey: "beaconUUID") }
    }

    var ndiSceneType: NdiSceneType {
        get { ud.enumValue(forKey: "ndiSceneType", default: .WORLD) }
        set { ud.set(newValue.rawValue, forKey: "ndiSceneType") }
    }

    // Note: UserDefaults key is "ndiType" (not "ndiWorldType") for backward compatibility
    var ndiWorldType: NdiWorldType {
        get { ud.enumValue(forKey: "ndiType", default: .CAMERA) }
        set { ud.set(newValue.rawValue, forKey: "ndiType") }
    }

    var ndiCameraPosition: CameraPosition {
        get { ud.enumValue(forKey: "ndiCameraPosition", default: .BACK) }
        set { ud.set(newValue.rawValue, forKey: "ndiCameraPosition") }
    }

    var depthType: DepthType {
        get { ud.enumValue(forKey: "depthType", default: .DEPTH) }
        set { ud.set(newValue.rawValue, forKey: "depthType") }
    }

    var ndiHumanType: NdiHumanType {
        get { ud.enumValue(forKey: "ndiHumanType", default: .HUMAN) }
        set { ud.set(newValue.rawValue, forKey: "ndiHumanType") }
    }

    var ndiResolution: VideoResolution {
        get { ud.enumValue(forKey: "ndiResolution", default: .vga) }
        set { ud.set(newValue.rawValue, forKey: "ndiResolution") }
    }

    var ndiAudioEnabled: NdiAudioEnabled {
        get { ud.enumValue(forKey: "ndiAudioEnabled", default: .enabled) }
        set { ud.set(newValue.rawValue, forKey: "ndiAudioEnabled") }
    }

    var ndiAudioBufferSize: NdiAudioBufferSize {
        get { ud.enumValue(forKey: "ndiAudioBufferSize", default: .large) }
        set { ud.set(newValue.rawValue, forKey: "ndiAudioBufferSize") }
    }

    var arkitTrackingType: ArkitTrackingType {
        get { ud.enumValue(forKey: "arkitTrackingType", default: .device) }
        set { ud.set(newValue.rawValue, forKey: "arkitTrackingType") }
    }

    var arkitFeaturePointsEnabled: ArkitFeaturePointsEnabled {
        get { ud.enumValue(forKey: "arkitFeaturePointsEnabled", default: .enabled) }
        set { ud.set(newValue.rawValue, forKey: "arkitFeaturePointsEnabled") }
    }

    var imageDetectorType: ImageDetectorType {
        get { ud.enumValue(forKey: "imageDetectorType", default: .face) }
        set { ud.set(newValue.rawValue, forKey: "imageDetectorType") }
    }

    // Note: UserDefaults key is "userImageDetectorCameraPosition" for backward compatibility
    var imageDetectorCameraPosition: CameraPosition {
        get { ud.enumValue(forKey: "userImageDetectorCameraPosition", default: .BACK) }
        set { ud.set(newValue.rawValue, forKey: "userImageDetectorCameraPosition") }
    }

    // Note: UserDefaults key is "userImageDetectorResolution" for backward compatibility
    var imageDetectorResolution: VideoResolution {
        get { ud.enumValue(forKey: "userImageDetectorResolution", default: .vga) }
        set { ud.set(newValue.rawValue, forKey: "userImageDetectorResolution") }
    }

    var imageDetectorAccuracy: ImageDetectorAccuracy {
        get { ud.enumValue(forKey: "imageDetectorAccuracy", default: .high) }
        set { ud.set(newValue.rawValue, forKey: "imageDetectorAccuracy") }
    }

    var imageDetectorTracks: Bool {
        get { ud.object(forKey: "imageDetectorTracks") != nil ? ud.bool(forKey: "imageDetectorTracks") : true }
        set { ud.set(newValue, forKey: "imageDetectorTracks") }
    }

    var imageDetectorNumberOfAngles: ImageDetectorNumberOfAngles {
        get { ud.enumValue(forKey: "imageDetectorNumberOfAngles", default: .one) }
        set { ud.set(newValue.rawValue, forKey: "imageDetectorNumberOfAngles") }
    }

    var imageDetectorDetectsEyeBlink: Bool {
        get { ud.object(forKey: "imageDetectorDetectsEyeBlink") != nil ? ud.bool(forKey: "imageDetectorDetectsEyeBlink") : true }
        set { ud.set(newValue, forKey: "imageDetectorDetectsEyeBlink") }
    }

    var imageDetectorDetectsSmile: Bool {
        get { ud.object(forKey: "imageDetectorDetectsSmile") != nil ? ud.bool(forKey: "imageDetectorDetectsSmile") : true }
        set { ud.set(newValue, forKey: "imageDetectorDetectsSmile") }
    }
    // swiftlint:enable line_length

    // MARK: - public methods

    public func getSettingsForOutput() -> [(String, String)] {
        let dst = dataDestination == .otherApp ? "OTHER APP" : "LOCAL FILE"
        let prot = transportProtocol == .TCP ? "TCP" : "UDP"
        let format = transportFormat == .OSC ? "OSC" : "JSON"

        return [
            ("Data Destination", dst),
            ("Protocol", prot),
            ("IP Address", ipAddress),
            ("Port", String(portNumber)),
            ("Message Format", format),
            ("Device UUID", deviceUUID),
        ]
    }

    public func isCameraUsed(exceptBy command: Command? = nil) -> Bool {
        var isCameraUsed = false
        if command != .arkit {
            isCameraUsed = (isCameraUsed || (isActiveByCommand[.arkit] ?? false))
        }
        if command != .ndi {
            isCameraUsed = (isCameraUsed || (isActiveByCommand[.ndi] ?? false))
        }
        if command != .imageDetection {
            isCameraUsed = (isCameraUsed || (isActiveByCommand[.imageDetection] ?? false))
        }

        return isCameraUsed
    }

    public func isTouchEnabled() -> Bool {
        return (AppSettingModel.shared.isActiveByCommand[.touch] ?? false) ||
            (AppSettingModel.shared.isActiveByCommand[.applePencil] ?? false)
    }
}

// MARK: - Private helpers

private extension AppSettingModel {
    var ud: UserDefaults { .standard }
}

private extension UserDefaults {
    func enumValue<T: RawRepresentable>(forKey key: String, default defaultValue: T) -> T where T.RawValue == Int {
        guard object(forKey: key) != nil else { return defaultValue }
        return T(rawValue: integer(forKey: key)) ?? defaultValue
    }
}
