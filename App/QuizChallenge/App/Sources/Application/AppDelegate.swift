//
//  AppDelegate.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 20/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupApplicationRoot()
        
        return true
    }
}
private extension AppDelegate {
    func setupApplicationRoot() {
        let rootViewController = makeKeywordsViewController()
        window = UIWindow()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}

