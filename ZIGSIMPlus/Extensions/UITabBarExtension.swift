//
//  UITabBarExtension.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/06/13.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import Foundation
import UIKit

let tabbarHeight = 80
extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        guard let window = UIApplication.shared.keyWindow else {
            return super.sizeThatFits(size)
        }
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = window.safeAreaInsets.bottom + CGFloat(tabbarHeight)
        return sizeThatFits
    }
}
