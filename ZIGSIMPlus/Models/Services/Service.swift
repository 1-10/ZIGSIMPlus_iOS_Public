//
//  Service.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/07/09.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import SwiftOSC
import SwiftyJSON

protocol Service {
    func toLog() -> [String]
    func toOSC() -> [OSCMessage]
    func toJSON() throws -> JSON
}

extension Service {
    func osc(_ address: String, _ args: OSCType?...) -> OSCMessage {
        let deviceUUID = AppSettingModel.shared.deviceUUID
        return OSCMessage(OSCAddressPattern("/ZIGSIM/\(deviceUUID)/\(address)"), args)
    }
}
