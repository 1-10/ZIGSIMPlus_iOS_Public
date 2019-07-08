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
        for viewController in viewControllers {
            if type(of: viewController) == CommandOutputViewController.self {
                let vc = viewController as! CommandOutputViewController
                vc.presenter = CommandOutputPresenter(view: vc)
            }
        }
    }
}
