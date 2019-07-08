//
//  CommandPlayer.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/09.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation

enum CommandPlayerState {
    case playing
    case paused
    case stopped
}

public class CommandPlayer {
    static let shared = CommandPlayer()
    private init() {}

    private var updatingTimer: Timer?
    public var onUpdate: (() -> Void)?
    private var state: CommandPlayerState = .stopped

    // MARK: - Public methods

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

        let data = ServiceManager.shared.getData()
        NetworkAdapter.shared.send(data)

        onUpdate?()
    }

    @objc private func monitorCommands() {
        if isActive(.battery) {
            BatteryService.shared.updateBattery()
        }
        if isActive(.remoteControl) {
            RemoteControlService.shared.update()
        }

        let data = ServiceManager.shared.getData()
        NetworkAdapter.shared.send(data)

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
}
