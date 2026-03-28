// Generated using Sourcery 2.3.0 — https://github.com/krzysztofzablocki/Sourcery
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
private var ndiSceneTypeKey: Void?
private var ndiWorldTypeKey: Void?
private var ndiCameraPositionKey: Void?
private var depthTypeKey: Void?
private var ndiHumanTypeKey: Void?
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
            return getAssociatedObject(self, &dataDestinationKey) ?? Defaults[key: DefaultsKeys.dataDestination]
        }
        set {
            setRetainedAssociatedObject(self, &dataDestinationKey, newValue)
            Defaults[key: DefaultsKeys.dataDestination] = newValue
        }
    }

    var transportProtocol: TransportProtocol {
        get {
            return getAssociatedObject(self, &transportProtocolKey) ?? Defaults[key: DefaultsKeys.transportProtocol]
        }
        set {
            setRetainedAssociatedObject(self, &transportProtocolKey, newValue)
            Defaults[key: DefaultsKeys.transportProtocol] = newValue
        }
    }

    var ipAddress: String {
        get {
            return getAssociatedObject(self, &ipAddressKey) ?? Defaults[key: DefaultsKeys.ipAddress]
        }
        set {
            setRetainedAssociatedObject(self, &ipAddressKey, newValue)
            Defaults[key: DefaultsKeys.ipAddress] = newValue
        }
    }

    var portNumber: Int {
        get {
            return getAssociatedObject(self, &portNumberKey) ?? Defaults[key: DefaultsKeys.portNumber]
        }
        set {
            setRetainedAssociatedObject(self, &portNumberKey, newValue)
            Defaults[key: DefaultsKeys.portNumber] = newValue
        }
    }

    var transportFormat: TransportFormat {
        get {
            return getAssociatedObject(self, &transportFormatKey) ?? Defaults[key: DefaultsKeys.transportFormat]
        }
        set {
            setRetainedAssociatedObject(self, &transportFormatKey, newValue)
            Defaults[key: DefaultsKeys.transportFormat] = newValue
        }
    }

    var messageRatePerSecond: RatePerSecond {
        get {
            return getAssociatedObject(self, &messageRatePerSecondKey) ?? Defaults[key: DefaultsKeys.messageRatePerSecond]
        }
        set {
            setRetainedAssociatedObject(self, &messageRatePerSecondKey, newValue)
            Defaults[key: DefaultsKeys.messageRatePerSecond] = newValue
        }
    }

    var compassOrientation: CompassOrientation {
        get {
            return getAssociatedObject(self, &compassOrientationKey) ?? Defaults[key: DefaultsKeys.compassOrientation]
        }
        set {
            setRetainedAssociatedObject(self, &compassOrientationKey, newValue)
            Defaults[key: DefaultsKeys.compassOrientation] = newValue
        }
    }

    var deviceUUID: String {
        get {
            return getAssociatedObject(self, &deviceUUIDKey) ?? Defaults[key: DefaultsKeys.deviceUUID]
        }
        set {
            setRetainedAssociatedObject(self, &deviceUUIDKey, newValue)
            Defaults[key: DefaultsKeys.deviceUUID] = newValue
        }
    }

    var beaconUUID: String {
        get {
            return getAssociatedObject(self, &beaconUUIDKey) ?? Defaults[key: DefaultsKeys.beaconUUID]
        }
        set {
            setRetainedAssociatedObject(self, &beaconUUIDKey, newValue)
            Defaults[key: DefaultsKeys.beaconUUID] = newValue
        }
    }

    var ndiSceneType: NdiSceneType {
        get {
            return getAssociatedObject(self, &ndiSceneTypeKey) ?? Defaults[key: DefaultsKeys.ndiSceneType]
        }
        set {
            setRetainedAssociatedObject(self, &ndiSceneTypeKey, newValue)
            Defaults[key: DefaultsKeys.ndiSceneType] = newValue
        }
    }

    var ndiWorldType: NdiWorldType {
        get {
            return getAssociatedObject(self, &ndiWorldTypeKey) ?? Defaults[key: DefaultsKeys.ndiWorldType]
        }
        set {
            setRetainedAssociatedObject(self, &ndiWorldTypeKey, newValue)
            Defaults[key: DefaultsKeys.ndiWorldType] = newValue
        }
    }

    var ndiCameraPosition: CameraPosition {
        get {
            return getAssociatedObject(self, &ndiCameraPositionKey) ?? Defaults[key: DefaultsKeys.ndiCameraPosition]
        }
        set {
            setRetainedAssociatedObject(self, &ndiCameraPositionKey, newValue)
            Defaults[key: DefaultsKeys.ndiCameraPosition] = newValue
        }
    }

    var depthType: DepthType {
        get {
            return getAssociatedObject(self, &depthTypeKey) ?? Defaults[key: DefaultsKeys.depthType]
        }
        set {
            setRetainedAssociatedObject(self, &depthTypeKey, newValue)
            Defaults[key: DefaultsKeys.depthType] = newValue
        }
    }

    var ndiHumanType: NdiHumanType {
        get {
            return getAssociatedObject(self, &ndiHumanTypeKey) ?? Defaults[key: DefaultsKeys.ndiHumanType]
        }
        set {
            setRetainedAssociatedObject(self, &ndiHumanTypeKey, newValue)
            Defaults[key: DefaultsKeys.ndiHumanType] = newValue
        }
    }

    var ndiResolution: VideoResolution {
        get {
            return getAssociatedObject(self, &ndiResolutionKey) ?? Defaults[key: DefaultsKeys.ndiResolution]
        }
        set {
            setRetainedAssociatedObject(self, &ndiResolutionKey, newValue)
            Defaults[key: DefaultsKeys.ndiResolution] = newValue
        }
    }

    var ndiAudioEnabled: NdiAudioEnabled {
        get {
            return getAssociatedObject(self, &ndiAudioEnabledKey) ?? Defaults[key: DefaultsKeys.ndiAudioEnabled]
        }
        set {
            setRetainedAssociatedObject(self, &ndiAudioEnabledKey, newValue)
            Defaults[key: DefaultsKeys.ndiAudioEnabled] = newValue
        }
    }

    var ndiAudioBufferSize: NdiAudioBufferSize {
        get {
            return getAssociatedObject(self, &ndiAudioBufferSizeKey) ?? Defaults[key: DefaultsKeys.ndiAudioBufferSize]
        }
        set {
            setRetainedAssociatedObject(self, &ndiAudioBufferSizeKey, newValue)
            Defaults[key: DefaultsKeys.ndiAudioBufferSize] = newValue
        }
    }

    var arkitTrackingType: ArkitTrackingType {
        get {
            return getAssociatedObject(self, &arkitTrackingTypeKey) ?? Defaults[key: DefaultsKeys.arkitTrackingType]
        }
        set {
            setRetainedAssociatedObject(self, &arkitTrackingTypeKey, newValue)
            Defaults[key: DefaultsKeys.arkitTrackingType] = newValue
        }
    }

    var arkitFeaturePointsEnabled: ArkitFeaturePointsEnabled {
        get {
            return getAssociatedObject(self, &arkitFeaturePointsEnabledKey) ?? Defaults[key: DefaultsKeys.arkitFeaturePointsEnabled]
        }
        set {
            setRetainedAssociatedObject(self, &arkitFeaturePointsEnabledKey, newValue)
            Defaults[key: DefaultsKeys.arkitFeaturePointsEnabled] = newValue
        }
    }

    var imageDetectorType: ImageDetectorType {
        get {
            return getAssociatedObject(self, &imageDetectorTypeKey) ?? Defaults[key: DefaultsKeys.imageDetectorType]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorTypeKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorType] = newValue
        }
    }

    var imageDetectorCameraPosition: CameraPosition {
        get {
            return getAssociatedObject(self, &imageDetectorCameraPositionKey) ?? Defaults[key: DefaultsKeys.imageDetectorCameraPosition]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorCameraPositionKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorCameraPosition] = newValue
        }
    }

    var imageDetectorResolution: VideoResolution {
        get {
            return getAssociatedObject(self, &imageDetectorResolutionKey) ?? Defaults[key: DefaultsKeys.imageDetectorResolution]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorResolutionKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorResolution] = newValue
        }
    }

    var imageDetectorAccuracy: ImageDetectorAccuracy {
        get {
            return getAssociatedObject(self, &imageDetectorAccuracyKey) ?? Defaults[key: DefaultsKeys.imageDetectorAccuracy]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorAccuracyKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorAccuracy] = newValue
        }
    }

    var imageDetectorTracks: Bool {
        get {
            return getAssociatedObject(self, &imageDetectorTracksKey) ?? Defaults[key: DefaultsKeys.imageDetectorTracks]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorTracksKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorTracks] = newValue
        }
    }

    var imageDetectorNumberOfAngles: ImageDetectorNumberOfAngles {
        get {
            return getAssociatedObject(self, &imageDetectorNumberOfAnglesKey) ?? Defaults[key: DefaultsKeys.imageDetectorNumberOfAngles]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorNumberOfAnglesKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorNumberOfAngles] = newValue
        }
    }

    var imageDetectorDetectsEyeBlink: Bool {
        get {
            return getAssociatedObject(self, &imageDetectorDetectsEyeBlinkKey) ?? Defaults[key: DefaultsKeys.imageDetectorDetectsEyeBlink]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorDetectsEyeBlinkKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorDetectsEyeBlink] = newValue
        }
    }

    var imageDetectorDetectsSmile: Bool {
        get {
            return getAssociatedObject(self, &imageDetectorDetectsSmileKey) ?? Defaults[key: DefaultsKeys.imageDetectorDetectsSmile]
        }
        set {
            setRetainedAssociatedObject(self, &imageDetectorDetectsSmileKey, newValue)
            Defaults[key: DefaultsKeys.imageDetectorDetectsSmile] = newValue
        }
    }
}
