//
//  PresenterFactory.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 2019/06/12.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import Foundation
import UIKit

class PresenterFactory {
    func createCommandSelectionPresenter(parentView: UINavigationController) {
        for viewController in parentView.viewControllers {
            if type(of: viewController) == CommandSelectionViewController.self {
                let vc = viewController as! CommandSelectionViewController
                vc.presenter = CommandSelectionPresenter(view: vc)
            }
        }
    }
    
    func createCommandOutputViewController(parentView: UINavigationController) {
        for viewController in parentView.viewControllers {
            if type(of: viewController) == CommandOutputViewController.self {
                let vc = viewController as! CommandOutputViewController
                vc.presenter = CommandOutputPresenter(view: vc)
            }
        }
    }
    
    func createCommandSettingPresenter(parentView: UINavigationController) {
        for viewController in parentView.viewControllers {
            if type(of: viewController) == CommandSettingViewController.self {
                let vc = viewController as! CommandSettingViewController
                vc.presenter = CommandSettingPresenter(view: vc)
            }
        }
    }
    
    func createVideoCapturePresenter(parentView: CommandOutputViewController) {
        for viewController in parentView.children {
            if type(of: viewController) == VideoCaptureViewController.self {
                let vc = viewController as! VideoCaptureViewController
                vc.presenter = VideoCapturePresenter(view: vc)
            }
        }
    }
}
