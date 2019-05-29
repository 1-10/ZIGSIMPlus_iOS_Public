//
//  RemoteControlCommand.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/29.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import MediaPlayer
import UIKit

public final class RemoteControlCommand: AutoUpdatedCommand {
    
    public func start(completion: ((String?) -> Void)?) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(volumeChanged(notification:)),
            name: NSNotification.Name("AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
    }

    public func stop(completion: ((String?) -> Void)?) {
        NotificationCenter.default.removeObserver(
            self,
            name: Notification.Name("AVSystemController_SystemVolumeDidChangeNotification"),
            object: nil
        )
        completion?(nil)
    }

    @objc func volumeChanged(notification: NSNotification) {
        let volume = notification.userInfo!["AVSystemController_AudioVolumeNotificationParameter"] as! Float
        print(">> yo volume:\(volume)")

//        //Get the slider by its tag
//        let volumeView = self.view.viewWithTag(100) as! UISlider
//        //Update the slider value to correspond to the volume
//        volumeView.value = volume
    }
}

