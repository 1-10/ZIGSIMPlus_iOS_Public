//
//  RemoteControlCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/29.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import MediaPlayer

public final class RemoteControlCommand: NSObject, AutoUpdatedCommand {
    let audioEngine = AVAudioEngine()
    let playerNode = AVAudioPlayerNode()
    var isPlaying = false

    override init() {
        // Create dummy audioEngine.
        // We don't play audio, but we need it to receive MPRemoteCommandCenter commands.
        // cf. https://developer.apple.com/documentation/mediaplayer/handling_external_player_events_notifications
        let audioFormat = playerNode.outputFormat(forBus: 0)
        audioEngine.attach(playerNode)
        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
    }

    public func start(completion: ((String?) -> Void)?) {
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

    public func stop(completion: ((String?) -> Void)?) {
        audioEngine.pause()

        // Remove triggers
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name("AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
        MPRemoteCommandCenter.shared().togglePlayPauseCommand.removeTarget(self, action: #selector(onTogglePlayPause(_:)))

        completion?(nil)
    }

    @objc func onVolumeChange(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        print(">> yo volume:\(volume)")
    }

    @objc func onTogglePlayPause(_ event: MPRemoteCommandEvent) {
        isPlaying.toggle()
        print(">> yo toggle:\(isPlaying)")
    }
}
