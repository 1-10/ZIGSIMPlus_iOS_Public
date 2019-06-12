//
//  CommandSettingTabNavigationController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/12.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

class CommandSettingTabNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize child view controllers
        for viewController in viewControllers {
            if type(of: viewController) == CommandSettingViewController.self {
                let vc = viewController as! CommandSettingViewController
                vc.presenter = CommandSettingPresenter(view: vc)
            }
        }
    }
}
