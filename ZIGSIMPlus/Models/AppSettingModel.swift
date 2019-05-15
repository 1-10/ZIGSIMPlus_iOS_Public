//
//  AppSettingModel.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public class AppSettingModel {
    private init() {}
    static let shared = AppSettingModel()
    
    var isAccelerationMonitoringActive: Bool = false
    var isBatteryMonitoringActive: Bool = false
}
