//
//  CommandSelectionTabNavigationController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/17.
//  Copyright © 2019 Nozomu Kuwae. All rights reserved.
//

import UIKit

class CommandSelectionTabNavigationController: UINavigationController {
    var mediator: CommandAndServiceMediator?

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
    }

    func setMediator(_ mediator: CommandAndServiceMediator) {
        self.mediator = mediator
    }
}
