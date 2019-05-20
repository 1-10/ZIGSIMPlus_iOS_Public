//
//  LabelConstants.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation

public struct LabelConstants {
    public static let accelaration = "Acceleration"
    public static let battery = "Battery"
    public static let pressure = "Pressure"
    public static let autoUpdatedCommands: [String] = [accelaration,pressure]
    public static let manualUpdatedCommands: [String] = [battery]
    
    public static var commands: [String] {
        return autoUpdatedCommands + manualUpdatedCommands
    }
}
