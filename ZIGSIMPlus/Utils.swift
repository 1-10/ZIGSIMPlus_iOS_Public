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

    static func setTitleImage(_ navBar: UINavigationBar) {
        let bounds = navBar.bounds
        let center = navBar.center

        let titleImage = UIImage(named: "Logo")
        let titleImageView = UIImageView(image: titleImage)

        // Get dimension to render image
        let scale = bounds.height / titleImage!.size.height
        let imageWidth = titleImage!.size.width * scale
        let imageHeight = titleImage!.size.height * scale

        // Set image frame to the center of the navBar
        titleImageView.frame = CGRect(
            x: center.x - imageWidth / 2,
            y: center.y - bounds.height / 2 - imageHeight,
            width: imageWidth,
            height: imageHeight
        )

        // Add wrapper to prevent automatic image resizing
        let wrapper = UIView(frame: bounds)
        wrapper.addSubview(titleImageView)

        navBar.topItem!.titleView = wrapper
    }

    static func isValidBeaconUUID(_ uuid: String) -> Bool {
        let re = try! NSRegularExpression(pattern: "[A-Z0-9]{8}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{12}")
        return re.matches(in: uuid, options: [], range: .init(location: 0, length: uuid.count)).count != 0
    }

    static func formatBeaconUUID(_ _uuid: String) -> String {
        var uuid = _uuid.uppercased()

        // Insert hyphens
        [8, 13, 18, 23].forEach { i in
            if uuid.count > i {
                let idx = uuid.index(uuid.startIndex, offsetBy: i)
                if uuid[idx] != "-" {
                    uuid.insert("-", at: idx)
                }
            }
        }

        // Limit length
        if uuid.count > 36 {
            let idx = uuid.index(uuid.startIndex, offsetBy: 36)
            uuid = String(uuid[..<idx])
        }

        return uuid
    }
}
