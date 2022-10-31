// SceneDelegate.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// SceneDelegate
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navController = UINavigationController(rootViewController: IntroViewController())
        navController.navigationBar.backgroundColor = .clear
        navController.navigationBar.tintColor = .clear

        UINavigationBar.appearance().backgroundColor = .clear
        UINavigationBar.appearance().barTintColor = UIColor.clear
        UINavigationBar.appearance().shadowImage = UIImage()

        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
