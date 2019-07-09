//
//  CommandOutputTabNavigationController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/20.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import UIKit

class CommandOutputTabNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize child view controllers
        let factory = PresenterFactory()
        factory.createCommandOutputViewController(parentView: self)
    }
}
