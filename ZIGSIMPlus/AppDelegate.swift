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
