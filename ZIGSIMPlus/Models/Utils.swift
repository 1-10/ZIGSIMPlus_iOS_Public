//
//  Utils.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/05/22.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func randomStringWithLength(_ length: Int) -> String {
        let alphabet = "-_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<length).map { _ -> Character in alphabet.randomElement()! })
    }
    
    static func separateBeaconUuid(uuid: String, position: Int) -> String {
        let strTmp = uuid
        var separatedUuid:[String]
        if ((strTmp.range(of: "-")) != nil) {
            separatedUuid = strTmp.components(separatedBy: "-")
            if position >= 0 && position <= 4 && separatedUuid.count == 5 {
                return separatedUuid[position]
            }
        }
        return ""
    }

    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width * UIScreen.main.scale
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height * UIScreen.main.scale
    }

    // Remap values to range [-1, 1]
    static func remapToScreenCoord(_ pos: CGPoint) -> CGPoint {
        let bounds = UIScreen.main.bounds
        return CGPoint(
            x: pos.x / bounds.width * 2 - 1,
            y: pos.y / bounds.height * 2 - 1
        )
    }
    
    static func getTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: Date())
    }
}
