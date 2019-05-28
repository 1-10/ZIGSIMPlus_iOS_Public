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
        return UIScreen.main.bounds.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }

    // Remap values to range [-1, 1]
    static func remapToScreenCoord(_ pos: CGPoint) -> CGPoint {
        return CGPoint(
            x: pos.x / screenWidth * 2 - 1,
            y: pos.y / screenHeight * 2 - 1
        )
    }
}
