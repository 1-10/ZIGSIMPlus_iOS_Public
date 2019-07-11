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
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        next?.touchesBegan(touches, with: event)
    }
}
