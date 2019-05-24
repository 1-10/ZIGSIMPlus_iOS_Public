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
        GpsCompassData.shared.startCompass()
        GpsCompassData.shared.callbackCompass = { (compassData) in
            // compass:faceupは設定画面作成後に追加
            let appSetting = AppSettingModel.shared
            completion?("""
                compass:compass:\(compassData)
                compass:faceup:\(appSetting.compassAngle)
                """)
        }
    }
    
    public func stop(completion: ((String?) -> Void)?) {
        GpsCompassData.shared.stopCompass()
        completion?(nil)
    }
}


