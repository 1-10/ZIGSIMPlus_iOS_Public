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
                CommandAndServiceMediator.startCommand(command)
            }
        }

        if AppSettingModel.shared.dataDestination == .LOCAL_FILE {
            let data = ServiceManager.shared.getString()
            FileWriter.shared.open()
            FileWriter.shared.write(data)
        }
        else {
            let data = ServiceManager.shared.getData()
            NetworkAdapter.shared.send(data)
        }

        onUpdate?()
    }

    @objc private func monitorCommands() {
        if isActive(.battery) {
            BatteryService.shared.updateBattery()
        }
        if isActive(.remoteControl) {
            RemoteControlService.shared.update()
        }

        if AppSettingModel.shared.dataDestination == .LOCAL_FILE {
            let data = ServiceManager.shared.getString()
            FileWriter.shared.write(data)
        }
        else {
            let data = ServiceManager.shared.getData()
            NetworkAdapter.shared.send(data)
        }

        onUpdate?()
    }

    private func stopCommands() {
        guard let t = updatingTimer else { return }
        if t.isValid {
            t.invalidate()
        }

        for command in Command.allCases {
            if isActive(command) {
                CommandAndServiceMediator.stopCommand(command)
            }
        }

        FileWriter.shared.close()
        NetworkAdapter.shared.close()
    }

    private func isActive(_ command: Command) -> Bool {
        guard let b = AppSettingModel.shared.isActiveByCommand[command] else {
            fatalError("AppSetting for Command \"\(command)\" is nil")
        }
        return b
    }
}
