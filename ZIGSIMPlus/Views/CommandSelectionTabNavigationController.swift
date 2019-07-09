//
//  CommandSelectionTabNavigationController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import UIKit

class CommandSelectionTabNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize child view controllers
        let factory = PresenterFactory()
        factory.createCommandSelectionPresenter(parentView: self)
    }
}
