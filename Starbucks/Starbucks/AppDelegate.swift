//
//  AppDelegate.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/09.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is EventViewController {
            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "EventVC") {
                tabBarController.present(newVC, animated: true)
                return false
            }
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
