//
//  AppDelegate.swift
//  LimeUIKit
//
//  Created by Миша Перевозчиков on 06.03.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	 var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		  window?.backgroundColor = UIColor(named: "CustomBackground")
		  
        return true
    }

    // MARK: UISceneSession Lifecycle

	 @available(iOS 13.0, *)
	 func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

	 @available(iOS 13.0, *)
	 func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }
}

