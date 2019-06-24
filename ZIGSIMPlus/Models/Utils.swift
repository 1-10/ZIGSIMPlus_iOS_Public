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

    static func getTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: Date())
    }
    
    static func checkSettingText(text: UITextField, settingTextType: SettingTextType) -> Bool {
        switch settingTextType {
        case .IP_ADDRESS:
            return Utils.checkText(original: text.text ?? "0", structuredBy: "1234567890.")
        case .PORT_NUMBER:
            return Utils.checkText(original: text.text ?? "0", structuredBy: "1234567890")
        case .DEVICE_UUID:
            return Utils.checkText(original: text.text ?? "0", structuredBy: "-_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        }
    }
    
    private static func checkText(original: String, structuredBy chars: String) -> Bool {
        let characterSet = NSMutableCharacterSet()
        characterSet.addCharacters(in: chars)
        return original.trimmingCharacters(in: characterSet as CharacterSet).count <= 0
    }

}
