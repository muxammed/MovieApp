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
        // ViewController()
        let navController = UINavigationController(rootViewController: IntroViewController())
        navController.navigationBar.backgroundColor = .clear
        navController.navigationBar.tintColor = .clear

        UINavigationBar.appearance().backgroundColor = .clear // backgorund color with gradient
        // or
        UINavigationBar.appearance().barTintColor = UIColor.clear
        UINavigationBar.appearance().shadowImage = UIImage()
        // solid color
//        UINavigationBar.appearance().isTranslucent = false
//        UIBarButtonItem.appearance().tintColor = .magenta

        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
