//
//  CommandAndServiceMediator.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/05/21.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

enum CommandState {
    case playing
    case paused
    case stopped
}

public class CommandAndServiceMediator {

    private var updatingTimer: Timer?
    public var onUpdate: (() -> Void)?
    private var state: CommandState = .stopped

    // MARK: - Public methods

    /// Returns if the service for given command is available.
    ///
    /// Simultaneous use of multiple commands accessing camera is not allowed.
    public func isAvailable(_ command: Command) -> Bool {
        switch command {
        case .acceleration, .gravity, .gyro, .quaternion:
            return MotionService.shared.isAvailable()
        case .touch, .applePencil:
            return TouchService.shared.isAvailable()
        case .battery:
            return BatteryService.shared.isAvailable()
        case .compass, .gps, .beacon:
            return LocationService.shared.isLocationAvailable()
        case .pressure:
            return AltimeterService.shared.isAvailable()
        case .proximity:
            return ProximityService.shared.isAvailable()
        case .micLevel:
            return AudioLevelService.shared.isAvailable()
        case .arkit:
            if isCameraAvailable(for: .arkit) {
                return ArkitService.shared.isARKitAvailable()
            } else {
                return false
            }
        case .remoteControl:
            return RemoteControlService.shared.isAvailable()
        case .ndi:
            if isCameraAvailable(for: .ndi) {
                return VideoCaptureService.shared.isNDIAvailable()
            } else {
                return false
            }
        case .imageDetection:
            if isCameraAvailable(for: .imageDetection) {
                return VideoCaptureService.shared.isImageDetectionAvailable()
            } else {
                return false
            }
        case .nfc:
            return NFCService.shared.isAvailable()
        }
    }

    public func play() {
        if state == .stopped {
            startCommands()
            state = .playing
        }
    }

    public func pause() {
        if state == .playing {
            stopCommands()
            state = .paused
        }
    }

    public func resume() {
        if state == .paused {
            startCommands()
            state = .playing
        }
    }

    public func stop() {
        if state == .playing {
            stopCommands()
            state = .stopped
        }
    }

    public func isPremiumCommand(_ command: Command) -> Bool {
        if command == Command.ndi ||
            command == Command.arkit ||
            command == Command.imageDetection ||
            command == Command.nfc ||
            command == Command.applePencil{
            return true
        }
        return false
    }

    // MARK: - Private methods

    private func startCommands() {
        updatingTimer = Timer.scheduledTimer(
            timeInterval: Utils.getMessageInterval(),
            target: self,
            selector: #selector(self.monitorCommands),
            userInfo: nil,
            repeats: true)

        for command in Command.allCases {
            if isActive(command) {
                startCommand(command)
            }
        }

        ServiceManager.shared.send()
        onUpdate?()
    }

    @objc private func monitorCommands() {
        if isActive(.battery) {
            BatteryService.shared.updateBattery()
        }
        if isActive(.remoteControl) {
            RemoteControlService.shared.update()
        }

        ServiceManager.shared.send()
        onUpdate?()
    }

    private func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }

        for command in Command.allCases {
            if isActive(command) {
                stopCommand(command)
            }
        }

        NetworkAdapter.shared.close()
    }

    private func startCommand(_ command: Command) {
        switch command {
        case .acceleration, .gravity, .gyro, .quaternion:
            MotionService.shared.start()
        case .touch, .applePencil:
            TouchService.shared.enable()
        case .battery:
            BatteryService.shared.startBattery()
        case .compass:
            LocationService.shared.startCompass()
        case .gps:
            LocationService.shared.startGps()
        case .beacon:
            LocationService.shared.startBeacons()
        case .pressure:
            AltimeterService.shared.startAltimeter()
        case .proximity:
            ProximityService.shared.start()
        case .micLevel:
            AudioLevelService.shared.start()
        case .arkit:
            ArkitService.shared.start()
        case .remoteControl:
            RemoteControlService.shared.start()
        case .ndi, .imageDetection:
            VideoCaptureService.shared.start()
        case .nfc:
            NFCService.shared.start()
        }
    }

    private func stopCommand(_ command: Command) {
        switch command {
        case .acceleration, .gravity, .gyro, .quaternion:
            MotionService.shared.stop()
        case .touch, .applePencil:
            TouchService.shared.disable()
        case .battery:
            BatteryService.shared.stopBattery()
        case .compass:
            LocationService.shared.stopCompass()
        case .gps:
            LocationService.shared.stopGps()
        case .beacon:
            LocationService.shared.stopBeacons()
        case .pressure:
            AltimeterService.shared.stopAltimeter()
        case .proximity:
            ProximityService.shared.stop()
        case .micLevel:
            AudioLevelService.shared.stop()
        case .arkit:
            ArkitService.shared.stop()
        case .remoteControl:
            RemoteControlService.shared.stop()
        case .ndi, .imageDetection:
            VideoCaptureService.shared.stop()
        case .nfc:
            NFCService.shared.stop()
        }
    }

    private func isActive(_ command: Command) -> Bool {
        guard let b = AppSettingModel.shared.isActiveByCommand[command] else {
            fatalError("AppSetting for Command \"\(command)\" is nil")
        }
        return b
    }

    private func isCameraAvailable(for command: Command) -> Bool {
        // When camera is set to on by other command,
        // user cannot use camera
        return !AppSettingModel.shared.isCameraUsed(exceptBy: command)
    }
}
