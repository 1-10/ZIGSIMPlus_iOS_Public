//
//  AudioLevelService.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import AudioToolbox
import Foundation
import SwiftOSC
import SwiftyJSON

// swiftlint:disable:next function_parameter_count
func audioQueueInputCallback(inUserData: UnsafeMutableRawPointer?,
                             inAQ: AudioQueueRef,
                             inBuffer: AudioQueueBufferRef,
                             inStartTime: UnsafePointer<AudioTimeStamp>,
                             inNumberPacketDescriptions: UInt32,
                             inPacketDescs: UnsafePointer<AudioStreamPacketDescription>?) {}

class AudioLevelService {
    // Singleton instance
    static let shared = AudioLevelService()

    // MARK: - Instance Properties

    var queue: AudioQueueRef!
    var timer: Timer!
    var dataFormat = AudioStreamBasicDescription(
        mSampleRate: 44100.0,
        mFormatID: kAudioFormatLinearPCM,
        mFormatFlags: AudioFormatFlags(kLinearPCMFormatFlagIsBigEndian |
            kLinearPCMFormatFlagIsSignedInteger |
            kLinearPCMFormatFlagIsPacked),
        mBytesPerPacket: 2,
        mFramesPerPacket: 1,
        mBytesPerFrame: 2,
        mChannelsPerFrame: 1,
        mBitsPerChannel: 16,
        mReserved: 0
    )
    var averageLevel: Float = 0.0
    var maxLevel: Float = 0.0
    var callbackAudio: (([Float]) -> Void)?

    @objc func detectVolume(timer: Timer) {
        // Get level
        var levelMeter = AudioQueueLevelMeterState()
        var propertySize = UInt32(MemoryLayout<AudioQueueLevelMeterState>.size)

        AudioQueueGetProperty(
            queue,
            kAudioQueueProperty_CurrentLevelMeterDB,
            &levelMeter,
            &propertySize
        )

        averageLevel = levelMeter.mAveragePower
        maxLevel = levelMeter.mPeakPower
    }

    // MARK: - Public methods

    func isAvailable() -> Bool {
        return true
    }

    public func start() {
        let fps = Utils.getMessageInterval()

        // Set data format
        var dataFormat = AudioStreamBasicDescription(
            mSampleRate: 44100.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: AudioFormatFlags(
                kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked
            ),
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )

        // Observe input level
        var audioQueue: AudioQueueRef?
        var error = noErr
        error = AudioQueueNewInput(
            &dataFormat,
            audioQueueInputCallback,
            unsafeBitCast(self, to: UnsafeMutableRawPointer.self),
            CFRunLoopGetCurrent(),
            CFRunLoopMode.commonModes.rawValue,
            0,
            &audioQueue
        )

        if error == noErr {
            queue = audioQueue
        }
        AudioQueueStart(queue, nil)

        // Enable level meter
        var enabledLevelMeter: UInt32 = 1
        AudioQueueSetProperty(
            queue,
            kAudioQueueProperty_EnableLevelMetering,
            &enabledLevelMeter,
            UInt32(MemoryLayout<UInt32>.size)
        )
        timer = Timer.scheduledTimer(
            timeInterval: fps,
            target: self,
            selector: #selector(AudioLevelService.detectVolume(timer:)),
            userInfo: nil,
            repeats: true
        )
        timer?.fire()
    }

    public func stop() {
        // Finish observation
        timer.invalidate()
        timer = nil
        AudioQueueFlush(queue)
        AudioQueueStop(queue, false)
        AudioQueueDispose(queue, true)
    }
}

extension AudioLevelService: Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommand[Command.micLevel]! {
            log += [
                "miclevel:max\(maxLevel)",
                "miclevel:average\(averageLevel)",
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        var data = [OSCMessage]()

        if AppSettingModel.shared.isActiveByCommand[Command.micLevel]! {
            data.append(osc("miclevel", maxLevel, averageLevel))
        }

        return data
    }

    func toJSON() -> JSON {
        var data = JSON()

        if AppSettingModel.shared.isActiveByCommand[Command.micLevel]! {
            data["miclevel"] = [
                "average": averageLevel,
                "max": maxLevel,
            ]
        }

        return data
    }
}
