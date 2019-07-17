//
//  UIColorExtension.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/20.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ hex: Int, alpha: CGFloat) {
        let red = CGFloat(hex / Int(powf(256, 2)) % 256) / 255
        let green = CGFloat(hex / Int(powf(256, 1)) % 256) / 255
        let blue = CGFloat(hex / Int(powf(256, 0)) % 256) / 255
        self.init(red: red, green: green, blue: blue, alpha: min(max(alpha, 0), 1))
    }

    convenience init(_ hex: Int) {
        self.init(hex, alpha: 1.0)
    }
}
