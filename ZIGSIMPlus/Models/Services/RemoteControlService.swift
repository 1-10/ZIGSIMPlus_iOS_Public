//
//  RemoteControlService.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/30.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import MediaPlayer
import os.log
import OSCKit
import SwiftyJSON

public class RemoteControlService: NSObject {
    // Singleton instance
    static let shared = RemoteControlService()
    private static let log = OSLog(
        subsystem: Bundle.main.bundleIdentifier ?? "com.zigsim",
        category: "RemoteControlService"
    )

    // MARK: - Instance Properties

    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    var isEnabled = false

    var isPlaying = false
    var volume = 0.0

    var lastIsPlaying = false /// isPlaying of last frame
    var lastVolume = 0.0 /// volume of last frame

    var playPauseChanged = false
    var volumeUp = false
    var volumeDown = false

    private override init() {
        // Create dummy audioEngine.
        // We don't play audio, but we need it to receive MPRemoteCommandCenter commands.
        // cf. https://developer.apple.com/documentation/mediaplayer/handling_external_player_events_notifications
        let audioFormat = playerNode.outputFormat(forBus: 0)
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
    }

    @objc func onVolumeChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let value = userInfo["AVSystemController_AudioVolumeNotificationParameter"] as? Double else {
            return
        }
        volume = value
    }

    @objc func onTogglePlayPause(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        isPlaying.toggle()
        return .success
    }

    // MARK: - Internal methods

    func start() {
        if isEnabled { return }
        isEnabled = true

        // Start audioengine and add trigger for play/pause button
        do {
            try audioEngine.start()
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget(
                self,
                action: #selector(onTogglePlayPause(_:))
            )
        } catch {
            os_log(
                "Failed to start audio engine: %{public}@",
                log: Self.log,
                type: .error,
                String(describing: error)
            )
        }

        // Add trigger for volumes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onVolumeChange(notification:)),
            name: NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
    }

    func stop() {
        if !isEnabled { return }
        isEnabled = false

        audioEngine.pause()

        // Remove triggers
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name("AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.removeTarget(
            self,
            action: #selector(onTogglePlayPause(_:))
        )
    }

    /// Called every frame to convert button events to boolean values
    func update() {
        volumeUp = lastVolume < volume
        volumeDown = lastVolume > volume
        playPauseChanged = lastIsPlaying != isPlaying

        lastVolume = volume
        lastIsPlaying = isPlaying
    }

    func isAvailable() -> Bool {
        // MPRemoteControlCenter is supported on iOS 7.1+
        if #available(iOS 7.1, *) {
            return true
        }
        return false
    }
}

extension RemoteControlService: Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommand[Command.remoteControl] ?? false {
            log += [
                "remotecontrol:playpause \(playPauseChanged)",
                "remotecontrol:volumeup \(volumeUp)",
                "remotecontrol:volumedown \(volumeDown)",
                "remotecontrol:isPlaying \(isPlaying)",
                "remotecontrol:volume \(volume)",
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        var messages = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.remoteControl] ?? false {
            messages.append(osc(
                "remotecontrol",
                playPauseChanged,
                volumeUp,
                volumeDown,
                isPlaying,
                volume
            ))
        }

        return messages
    }

    func toJSON() throws -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommand[Command.remoteControl] ?? false {
            data["remotecontrol"] = JSON([
                "playpause": playPauseChanged,
                "volumeup": volumeUp,
                "volumedown": volumeDown,
                "isPlaying": isPlaying,
                "volume": volume,
            ])
        }

        return data
    }
}
