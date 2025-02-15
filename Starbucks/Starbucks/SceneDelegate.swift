//
//  SceneDelegate.swift
//  Starbucks
//
//  Created by juntaek.oh on 2022/05/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let now = Date()
        if let lastLogin =  UserDefaults.standard.object(forKey: "lastLogin") as? Date {

            if Calendar.current.dateComponents([.day], from: now) != Calendar.current.dateComponents([.day], from: lastLogin) {
                // 다른날
                UserDefaults.standard.set(true, forKey: "showModal")
            }

        } else {
            UserDefaults.standard.set(true, forKey: "showModal")
        }

        UserDefaults.standard.set(Date(), forKey: "lastLogin")

        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
