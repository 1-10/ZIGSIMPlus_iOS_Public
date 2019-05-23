//
//  CompassMonitoringCommand.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import CoreLocation

public final class CompassMonitoringCommand: AutoUpdatedCommand {
    
    public func start(completion: ((String?) -> Void)?) {
        LocationDataStore.shared.startCompass()
        LocationDataStore.shared.callbackCompass = { (compassData) in
            // compass:faceupは設定画面作成後に追加
            completion?("""
                compass:compass:\(compassData)
                compass:faceup:
                """)
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        LocationDataStore.shared.stopCompass()
        completion?(nil)
    }
}


