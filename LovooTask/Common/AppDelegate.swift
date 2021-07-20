//
//  AppDelegate.swift
//  LovooTask
//
//  Created by Ayman Ata on 7/15/21.
//  Copyright © 2021 Ayman Ata. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init()
        let navigationController: UINavigationController = .init()
        let navigator: AppNavigator = .init(window: window!, navController: navigationController)

//        KeyChainManager.logout()
//        UDHelper.isUserLoggedIn = false
        navigator.start()
        setupNavigationBar()
        
        return true
    }

    private func setupNavigationBar() {
        UINavigationBar.appearance().backgroundColor = .systemPurple
        UINavigationBar.appearance().barTintColor = .systemPurple
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 24)!]
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.init(name: "HelveticaNeue-Medium", size: 16)!,
            NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

