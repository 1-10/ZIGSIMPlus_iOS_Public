// Generated using Sourcery 0.16.1 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

//
//  AppSettingModelAutoSave.stencil
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/05.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

private func getAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer) -> T? {
    return objc_getAssociatedObject(object, key) as? T
}

private func setRetainedAssociatedObject<T>(_ object: Any, _ key: UnsafeRawPointer, _ value: T) {
    objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
}

private var dataDestinationKey: Void?
private var transportProtocolKey: Void?
private var ipAddressKey: Void?
private var portNumberKey: Void?
private var transportFormatKey: Void?
private var messageRatePerSecondKey: Void?
private var compassOrientationKey: Void?
private var deviceUUIDKey: Void?
private var beaconUUIDKey: Void?
private var ndiTypeKey: Void?
private var ndiCameraPositionKey: Void?
private var depthTypeKey: Void?
private var ndiResolutionKey: Void?
private var ndiAudioEnabledKey: Void?
private var ndiAudioBufferSizeKey: Void?
private var arkitTrackingTypeKey: Void?
private var arkitFeaturePointsEnabledKey: Void?
private var imageDetectorTypeKey: Void?
private var imageDetectorCameraPositionKey: Void?
private var imageDetectorResolutionKey: Void?
private var imageDetectorAccuracyKey: Void?
private var imageDetectorTracksKey: Void?
private var imageDetectorNumberOfAnglesKey: Void?
private var imageDetectorDetectsEyeBlinkKey: Void?
private var imageDetectorDetectsSmileKey: Void?

extension AppSettingModel {
    var dataDestination: DataDestination {
        get {
            return getAssociatedObject(self, &dataDestinationKey) ?? Defaults[.dataDestination]
        }
        set {
            setRetainedAssociatedObject(self, &dataDestinationKey, newValue)
            Defaults[.dataDestination] = newValue
        }
    }

    var transportProtocol: TransportProtocol {
        get {
            return getAssociatedObject(self, &transportProtocolKey) ?? Defaults[.transportProtocol]
        }
        set {
            setRetainedAssociatedObject(self, &transportProtocolKey, newValue)
            Defaults[.transportProtocol] = newValue
        }
    }

    var ipAddress: String {
        get {
            return getAssociatedObject(self, &ipAddressKey) ?? Defaults[.ipAddress]
        }
        set {
            setRetainedAssociatedObject(self, &ipAddressKey, newValue)
            Defaults[.ipAddress] = newValue
        }
    }

    var portNumber: Int {
        get {
            return getAssociatedObject(self, &portNumberKey) ?? Defaults[.portNumber]
        }
        set {
            setRetainedAssociatedObject(self, &portNumberKey, newValue)
            Defaults[.portNumber] = newValue
        }
    }

    var transportFormat: TransportFormat {
        get {
            return getAssociatedObject(self, &transportFormatKey) ?? Defaults[.transportFormat]
        }
        set {
            setRetainedAssociatedObject(self, &transportFormatKey, newValue)
            Defaults[.transportFormat] = newValue
        }
    }

    var messageRatePerSecond: RatePerSecond {
        get {
            return getAssociatedObject(self, &messageRatePerSecondKey) ?? Defaults[.messageRatePerSecond]
        }
        set {
            setRetainedAssociatedObject(self, &messageRatePerSecondKey, newValue)
            Defaults[.messageRatePerSecond] = newValue
        }
    }

    var compassOrientation: CompassOrientation {
        get {
            return getAssociatedObject(self, &compassOrientationKey) ?? Defaults[.compassOrientation]
        }
        set {
            setRetainedAssociatedObject(self, &compassOrientationKey, newValue)
            Defaults[.compassOrientation] = newValue
        }
    }

    var deviceUUID: String {
        get {
            return getAssociatedObject(self, &deviceUUIDKey) ?? Defaults[.deviceUUID]
        }
        set {
            setRetainedAssociatedObject(self, &deviceUUIDKey, newValue)
            Defaults[.deviceUUID] = newValue
        }
    }

    var beaconUUID: String {
        get {
            return getAssociatedObject(self, &beaconUUIDKey) ?? Defaults[.beaconUUID]
        }
        set {
            setRetainedAssociatedObject(self, &beaconUUIDKey, newValue)
            Defaults[.beaconUUID] = newValue
        }
    }

    var ndiType: NdiType {
        get {
            return getAssociatedObject(self, &ndiTypeKey) ?? Defaults[.ndiType]
        }
        set {
            setRetainedAssociatedObject(self, &ndiTypeKey, newValue)
            Defaults[.ndiType] = newValue
        }
    }

    var ndiCameraPosition: CameraPosition {
        get {
            return getAssociatedObject(self, &ndiCameraPositionKey) ?? Defaults[.ndiCameraPosition]
        }
        set {
            setRetainedAssociatedObject(self, &ndiCameraPositionKey, newValue)
            Defaults[.ndiCameraPosition] = newValue
        }
    }

    var depthType: DepthType {
        get {
            return getAssociatedObject(self, &depthTypeKey) ?? Defaults[.depthType]
        }
        set {
            setRetainedAssociatedObject(self, &depthTypeKey, newValue)
            Defaults[.depthType] = newValue
        }
    }

    var ndiResolution: VideoResolution {
        get {
            return getAssociatedObject(self, &ndiResolutionKey) ?? Defaults[.ndiResolution]
        }
        set {
            setRetainedAssociatedObject(self, &ndiResolutionKey, newValue)
            Defaults[.ndiResolution] = newValue
        }
    }

    var ndiAudioEnabled: NdiAudioEnabled {
        get {
            return getAssociatedObject(self, &ndiAudioEnabledKey) ?? Defaults[.ndiAudioEnabled]
        }
        set {
            setRetainedAssociatedObject(self, &ndiAudioEnabledKey, newValue)
            Defaults[.ndiAudioEnabled] = newValue
        }
    }

    var ndiAudioBufferSize: NdiAudioBufferSize {
        get {
            return getAssociatedObject(self, &ndiAudioBufferSizeKey) ?? Defaults[.ndiAudioBufferSize]
        }
        set {
            setRetainedAssociatedObject(self, &ndiAudioBufferSizeKey, newValue)
            Defaults[.ndiAudioBufferSize] = newValue
        }
    }

    var arkitTrackingType: ArkitTrackingType {
        get {
            return getAssociatedObject(self, &arkitTrackingTypeKey) ?? Defaults[.arkitTrackingType]
        }
        set {
            setRetainedAssociatedObject(self, &arkitTrackingTypeKey, newValue)
            Defaults[.arkitTrackingType] = newValue
        }
    }

    var arkitFeaturePointsEnabled: ArkitFeaturePointsEnabled {
        get {
            return getAssociatedObject(self, &arkitFeaturePointsEnabledKey) ?? Defaults[.arkitFeaturePointsEnabled]
        }
        set {
            setRetainedAssociatedObject(self, &arkitFeaturePointsEnabledKey, newValue)
            Defaults[.arkitFeaturePointsEnabled] = newValue
        }
    }

    var imageDetectorType: ImageDetectorType {
        get {
            return getAssociatedObject(self, &imageDetectorTypeKey) ?? Defaults[.imageDetectorType]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorTypeKey, newValue)
            Defaults[.imageDetectorType] = newValue
        }
    }

    var imageDetectorCameraPosition: CameraPosition {
        get {
            return getAssociatedObject(self, &imageDetectorCameraPositionKey) ?? Defaults[.imageDetectorCameraPosition]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorCameraPositionKey, newValue)
            Defaults[.imageDetectorCameraPosition] = newValue
        }
    }

    var imageDetectorResolution: VideoResolution {
        get {
            return getAssociatedObject(self, &imageDetectorResolutionKey) ?? Defaults[.imageDetectorResolution]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorResolutionKey, newValue)
            Defaults[.imageDetectorResolution] = newValue
        }
    }

    var imageDetectorAccuracy: ImageDetectorAccuracy {
        get {
            return getAssociatedObject(self, &imageDetectorAccuracyKey) ?? Defaults[.imageDetectorAccuracy]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorAccuracyKey, newValue)
            Defaults[.imageDetectorAccuracy] = newValue
        }
    }

    var imageDetectorTracks: Bool {
        get {
            return getAssociatedObject(self, &imageDetectorTracksKey) ?? Defaults[.imageDetectorTracks]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorTracksKey, newValue)
            Defaults[.imageDetectorTracks] = newValue
        }
    }

    var imageDetectorNumberOfAngles: ImageDetectorNumberOfAngles {
        get {
            return getAssociatedObject(self, &imageDetectorNumberOfAnglesKey) ?? Defaults[.imageDetectorNumberOfAngles]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorNumberOfAnglesKey, newValue)
            Defaults[.imageDetectorNumberOfAngles] = newValue
        }
    }

    var imageDetectorDetectsEyeBlink: Bool {
        get {
            return getAssociatedObject(self, &imageDetectorDetectsEyeBlinkKey) ?? Defaults[.imageDetectorDetectsEyeBlink]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorDetectsEyeBlinkKey, newValue)
            Defaults[.imageDetectorDetectsEyeBlink] = newValue
        }
    }

    var imageDetectorDetectsSmile: Bool {
        get {
            return getAssociatedObject(self, &imageDetectorDetectsSmileKey) ?? Defaults[.imageDetectorDetectsSmile]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorDetectsSmileKey, newValue)
            Defaults[.imageDetectorDetectsSmile] = newValue
        }
    }
}
