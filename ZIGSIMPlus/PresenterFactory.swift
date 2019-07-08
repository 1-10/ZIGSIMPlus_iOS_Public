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
    func createVideoCapturePresenter(parentView: CommandOutputViewController) {
        for viewController in parentView.children {
            if type(of: viewController) == VideoCaptureViewController.self {
                let vc = viewController as! VideoCaptureViewController
                vc.presenter = VideoCapturePresenter(view: vc)
            }
        }
    }
}
