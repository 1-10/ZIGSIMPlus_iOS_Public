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
        for viewController in viewControllers {
            if type(of: viewController) == CommandSelectionViewController.self {
                let vc = viewController as! CommandSelectionViewController
                vc.presenter = CommandSelectionPresenter(view: vc)
            }
        }
    }
}
