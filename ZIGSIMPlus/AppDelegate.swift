//
//  AppDelegate.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import StoreKit
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // It's recommended to add a transaction queue observer at application launch
        // See https://developer.apple.com/library/archive/technotes/tn2387/_index.html
        SKPaymentQueue.default().add(InAppPurchaseFacade.shared)

        // Inject dependency here
        composePresenters()

        // Setup tab bar styles
        UITabBar.appearance().barTintColor = Theme.dark
        UITabBar.appearance().tintColor = Theme.main

        return true
    }

    // These code can't be moved to applicationWillResignActive / applicationDidBecomeActive
    // Because NFC dialog invokes them and causes pause/resume loop.
    // See PR #86 for details.
    func applicationDidEnterBackground(_: UIApplication) {
        CommandPlayer.shared.pause()
    }

    func applicationWillEnterForeground(_: UIApplication) {
        CommandPlayer.shared.resume()
    }

    func applicationWillTerminate(_: UIApplication) {
        // It's recommended to remove a transaction queue observer at application termination
        // See https://developer.apple.com/library/archive/technotes/tn2387/_index.html
        SKPaymentQueue.default().remove(InAppPurchaseFacade.shared)
    }

    private func composePresenters() {
        let factory = PresenterFactory()
        let tabBarController = window?.rootViewController as! UITabBarController
        for viewController in tabBarController.viewControllers! {
            if type(of: viewController) == CommandSelectionTabNavigationController.self {
                let vc = viewController as! CommandSelectionTabNavigationController
                factory.createPresenter(parentView: vc, viewType: CommandSelectionViewController.self)
            } else if type(of: viewController) == CommandOutputTabNavigationController.self {
                let vc = viewController as! CommandOutputTabNavigationController
                factory.createPresenter(parentView: vc, viewType: CommandOutputViewController.self)
            } else if type(of: viewController) == CommandSettingTabNavigationController.self {
                let vc = viewController as! CommandSettingTabNavigationController
                factory.createPresenter(parentView: vc, viewType: CommandSettingViewController.self)
            }
        }
    }
}
