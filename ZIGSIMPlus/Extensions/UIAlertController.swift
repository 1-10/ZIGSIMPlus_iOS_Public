//
//  UIAlertController.swift
//  ZIGSIMPlus
//
//  Created by YoneyamaShunpei on 2019/11/07.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func setBackgroundColor(_ color: UIColor) {
        let firstSubview = view.subviews.first
        let alertController = firstSubview?.subviews.first
        alertController?.subviews.forEach {
            $0.backgroundColor = color
        }
    }
}
