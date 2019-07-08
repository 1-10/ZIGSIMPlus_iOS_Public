//
//  ZIGTextField.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/25.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import UIKit

/// UITextField with custom style
@IBDesignable
open class ZIGTextField: UITextField {

    func setup() {
        textColor = Theme.main
        backgroundColor = Theme.black
        layer.borderWidth = 1.0
        layer.cornerRadius = 4.0
        layer.borderColor = Theme.main.cgColor
        borderStyle = .roundedRect
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
