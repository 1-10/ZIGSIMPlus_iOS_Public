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
    func createPresenter<T> (parentView: UINavigationController, viewType: T.Type) where T: UIViewController {
        for viewController in parentView.viewControllers {
            if type(of: viewController) == viewType {
                if viewType == CommandSelectionViewController.self {
                    let vc = viewController as! CommandSelectionViewController
                    vc.presenter = CommandSelectionPresenter(view: vc)
                } else if viewType == CommandOutputViewController.self {
                    let vc = viewController as! CommandOutputViewController
                    vc.presenter = CommandOutputPresenter(view: vc)
                } else if viewType == CommandSettingViewController.self {
                    let vc = viewController as! CommandSettingViewController
                    vc.presenter = CommandSettingPresenter(view: vc)
                }
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
