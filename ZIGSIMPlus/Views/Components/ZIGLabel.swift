//
//  ZIGLabel.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/25.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

/// UITextField with custom style
@IBDesignable
open class ZIGLabel: UILabel {

    func setup() {
        textColor = Theme.main
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}
