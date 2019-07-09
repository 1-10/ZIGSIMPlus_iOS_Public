//
//  AppDelegate.swift
//  ZIGSIMPlus
//
//  Created by Nozomu Kuwae on 5/10/19.
//  Copyright © 2019 1→10, Inc. All rights reserved.
//

import UIKit
import StoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // It's recommended to add a transaction queue observer at application launch
        // See https://developer.apple.com/library/archive/technotes/tn2387/_index.html
        SKPaymentQueue.default().add(InAppPurchaseFacade.shared)
        
        // Inject dependency here
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

        // Setup tab bar styles
        UITabBar.appearance().barTintColor = Theme.dark
        UITabBar.appearance().tintColor = Theme.main

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        CommandPlayer.shared.pause()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {
        CommandPlayer.shared.resume()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // It's recommended to remove a transaction queue observer at application termination
        // See https://developer.apple.com/library/archive/technotes/tn2387/_index.html
        SKPaymentQueue.default().remove(InAppPurchaseFacade.shared)
    }
}
