//
//  AudioLevelService.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/21.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import AudioToolbox
import SwiftOSC

func AudioQueueInputCallback(inUserData: UnsafeMutableRawPointer?,
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
            self.queue,
            kAudioQueueProperty_CurrentLevelMeterDB,
            &levelMeter,
            &propertySize)
        
        averageLevel = levelMeter.mAveragePower
        maxLevel = levelMeter.mPeakPower
    }
    
    // MARK: - Public methods

    func isAvailable() -> Bool {
        return true
    }

    public func start() {
        let fps = Double(AppSettingModel.shared.messageRatePerSecond)
        
        // Set data format
        var dataFormat = AudioStreamBasicDescription(
            mSampleRate: 44100.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: AudioFormatFlags(kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked),
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0)
        
        // Observe input level
        var audioQueue: AudioQueueRef? = nil
        var error = noErr
        error = AudioQueueNewInput(
                           &dataFormat,
                           AudioQueueInputCallback,
                           unsafeBitCast(self, to: UnsafeMutableRawPointer.self),
                           CFRunLoopGetCurrent(),
                           CFRunLoopMode.commonModes.rawValue,
                           0,
                           &audioQueue)
        
        if error == noErr {
            self.queue = audioQueue
        }
        AudioQueueStart(self.queue, nil)
        
        // Enable level meter
        var enabledLevelMeter: UInt32 = 1
        AudioQueueSetProperty(self.queue, kAudioQueueProperty_EnableLevelMetering, &enabledLevelMeter, UInt32(MemoryLayout<UInt32>.size))
        self.timer = Timer.scheduledTimer(timeInterval: 1.0 / fps,
                                          target: self,
                                          selector: #selector(AudioLevelService.detectVolume(timer:)),
                                          userInfo: nil,
                                          repeats: true)
        self.timer?.fire()
    }
    
    public func stop() {
        // Finish observation
        self.timer.invalidate()
        self.timer = nil
        AudioQueueFlush(self.queue)
        AudioQueueStop(self.queue, false)
        AudioQueueDispose(self.queue, true)
    }
}

extension AudioLevelService : Service {
    func toLog() -> [String] {
        var log = [String]()

        if AppSettingModel.shared.isActiveByCommandData[Command.micLevel]! {
            log += [
                "miclevel:max\(maxLevel)",
                "miclevel:average\(averageLevel)",
            ]
        }

        return log
    }

    func toOSC() -> [OSCMessage] {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        var data = [OSCMessage]()
        
        if AppSettingModel.shared.isActiveByCommandData[Command.micLevel]! {
            data.append(OSCMessage(
                OSCAddressPattern("/\(deviceUUID)/miclevel"),
                averageLevel,
                maxLevel
            ))
        }
        
        return data
    }
    
    func toJSON() -> [String:AnyObject] {
        var data = [String:AnyObject]()
        
        if AppSettingModel.shared.isActiveByCommandData[Command.micLevel]! {
            data.merge([
                "miclevel": [
                    "average": averageLevel,
                    "max": maxLevel
                    ] as AnyObject
            ]) { $1 }
        }
        
        return data
    }
}

