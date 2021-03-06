//
//  SceneDelegate.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 5/8/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let dummyVC = SearchMainViewController()
        let nav = UINavigationController(rootViewController: dummyVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
}
