//
//  ZIGSegmentedControl.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/25.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

/// UISegmentedControl with custom style
@IBDesignable
open class ZIGSegmentedControl: UISegmentedControl {

    func setup() {
        tintColor = Theme.main
        layer.backgroundColor = Theme.black.cgColor
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : Theme.white], for: .selected)
    }

    public override init(items: [Any]?) {
        super.init(items: items)
        setup()
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
