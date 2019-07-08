//
//  CommandOutputTabNavigationController.swift
//  ZIGSIMPlus
//
//  Created by Takayosi Amagi on 2019/06/20.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import UIKit

class CommandOutputTabNavigationController: UINavigationController {
    private var mediator: CommandAndServiceMediator?

    override func viewDidLoad() {
        super.viewDidLoad()

        if mediator == nil {
            fatalError("CommandOutputTabNavigatorController.mediator is not initialized")
        }

        // Initialize child view controllers
        for viewController in viewControllers {
            if type(of: viewController) == CommandOutputViewController.self {
                let vc = viewController as! CommandOutputViewController
                vc.presenter = CommandOutputPresenter(view: vc, mediator: mediator!)
            }
        }
    }

    func setMediator(_ mediator: CommandAndServiceMediator) {
        self.mediator = mediator
    }
}
