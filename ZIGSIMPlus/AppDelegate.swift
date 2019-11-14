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

    // swiftlint:disable:next line_length
    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
    func applicationDidEnterBackground(_ application: UIApplication) {
        CommandPlayer.shared.pause()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        CommandPlayer.shared.resume()
    }

    func applicationWillTerminate(_ application: UIApplication) {}

    private func composePresenters() {
        let factory = PresenterFactory()

        // swiftlint:disable:next force_cast
        let tabBarController = window?.rootViewController as! UITabBarController

        for viewController in tabBarController.viewControllers! {
            if type(of: viewController) == CommandSelectionTabNavigationController.self {
                // swiftlint:disable:next force_cast
                let vc = viewController as! CommandSelectionTabNavigationController
                factory.createPresenter(parentView: vc, viewType: CommandSelectionViewController.self)
            } else if type(of: viewController) == CommandOutputTabNavigationController.self {
                // swiftlint:disable:next force_cast
                let vc = viewController as! CommandOutputTabNavigationController
                factory.createPresenter(parentView: vc, viewType: CommandOutputViewController.self)
            } else if type(of: viewController) == CommandSettingTabNavigationController.self {
                // swiftlint:disable:next force_cast
                let vc = viewController as! CommandSettingTabNavigationController
                factory.createPresenter(parentView: vc, viewType: CommandSettingViewController.self)
            }
        }
    }
}
