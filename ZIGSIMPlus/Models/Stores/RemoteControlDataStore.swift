//
//  RemoteControlDataStore.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/30.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import MediaPlayer
import SwiftOSC

public class RemoteControlDataStore: NSObject {
    // Singleton instance
    static let shared = RemoteControlDataStore()

    // MARK: - Instance Properties
    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    var isEnabled = false
    var volume = 0.0
    var isPlaying = false
    var lastVolume = 0.0
    var lastIsPlaying = false
    var callback: ((Bool, Double) -> Void)? = nil

    override private init() {
        // Create dummy audioEngine.
        // We don't play audio, but we need it to receive MPRemoteCommandCenter commands.
        // cf. https://developer.apple.com/documentation/mediaplayer/handling_external_player_events_notifications
        let audioFormat = playerNode.outputFormat(forBus: 0)
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
    }

    @objc func onVolumeChange(notification: NSNotification) {
        volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Double
        update()
    }

    @objc func onTogglePlayPause(_ event: MPRemoteCommandEvent) {
        isPlaying.toggle()
        update()
    }

    private func update() {
        print(">> remoteControl: (\(isPlaying), \(volume))")
        callback?(isPlaying, volume)
    }

    // MARK: - Internal methods
    func start() {
        if isEnabled { return }
        isEnabled = true

        // Start audioengine and add trigger for play/pause button
        do {
            try audioEngine.start()
            MPRemoteCommandCenter.shared().togglePlayPauseCommand.addTarget(self, action: #selector(onTogglePlayPause(_:)))
        } catch {
            print(">> yo Failed to start audio engine")
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

        audioEngine.pause()

        // Remove triggers
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name("AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.removeTarget(self, action: #selector(onTogglePlayPause(_:)))

    }

    func isAvailable() -> Bool {
        // MPRemoteControlCenter is supported on iOS 7.1+
        if #available(iOS 7.1, *) {
            return true
        }
        return false
    }
}

extension RemoteControlDataStore : Store {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommandData[Label.remoteControl]! {
            log += [
                "remotecontrol:playpause \(isPlaying)",
                "remotecontrol:volume \(volume)"
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var messages = [OSCMessage]()

        // Detect changes
        let volumeUp = lastVolume < volume
        let volumeDown = lastVolume > volume
        let playPauseChanged = lastIsPlaying != isPlaying
        lastVolume = volume
        lastIsPlaying = isPlaying

        if AppSettingModel.shared.isActiveByCommandData[Label.remoteControl]! {
            messages.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/remotecontrol"),
                playPauseChanged,
                volumeUp,
                volumeDown,
                isPlaying,
                volume
            ))
        }

        return messages
    }

    func toJSON() -> [String:AnyObject] {
        var data = [String:AnyObject]()

        // Detect changes
        let volumeUp = lastVolume < volume
        let volumeDown = lastVolume > volume
        let playPauseChanged = lastIsPlaying != isPlaying
        lastVolume = volume
        lastIsPlaying = isPlaying

        if AppSettingModel.shared.isActiveByCommandData[Label.remoteControl]! {
            data.merge([
                "remoteControl": [
                    "playpause": playPauseChanged,
                    "volumeup": volumeUp,
                    "volumedown": volumeDown,
                    "isPlaying": isPlaying,
                    "volume": volume
                    ] as AnyObject
            ]) { $1 }
        }

        return data
    }
}
