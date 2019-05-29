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
        LocationDataStore.shared.compassCallback = { (compassData) in
            let appSetting = AppSettingModel.shared
            completion?("""
                compass:compass:\(compassData)
                compass:faceup:\(appSetting.compassAngle)
                """)
        }
    }

    public func stop(completion: ((String?) -> Void)?) {
        LocationDataStore.shared.stopCompass()
        completion?(nil)
    }
}
