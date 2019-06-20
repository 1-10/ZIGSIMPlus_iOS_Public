//
//  CommandSelectionTabNavigationController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

class CommandSelectionTabNavigationController: UINavigationController {
    private var mediator: CommandAndServiceMediator?

    override func viewDidLoad() {
        super.viewDidLoad()

        if mediator == nil {
            fatalError("CommandSelectionTabNavigatorController.mediator is not initialized")
        }

        // Initialize child view controllers
        for viewController in viewControllers {
            if type(of: viewController) == CommandSelectionViewController.self {
                let vc = viewController as! CommandSelectionViewController
                vc.presenter = CommandSelectionPresenter(view: vc, mediator: mediator!)
            }
        }
        UITabBar.appearance().barTintColor = UIColor(displayP3Red: 13/255, green: 12/255, blue: 12/255, alpha: 1.0)
        UITabBar.appearance().tintColor = UIColor(displayP3Red: 0, green: 153/255, blue: 102/255, alpha: 1.0)
    }

    func setMediator(_ mediator: CommandAndServiceMediator) {
        self.mediator = mediator
    }
}
