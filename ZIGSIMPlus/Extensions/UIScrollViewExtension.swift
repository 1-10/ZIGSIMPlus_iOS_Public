//
//  UIScrollViewExtension.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/05/31.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}
