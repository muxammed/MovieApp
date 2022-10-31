// MainTabViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit
/// TabViewController контроллер табов в дальнейшем планирую певерсти в табы и добавить еще табы
final class MainTabViewController: UITabBarController {
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    // MARK: - Private Methods

    private func setupTabs() {
        let searchViewController = SearchViewController()
        let itemOne = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: Constants.searchIconName),
            selectedImage: UIImage(systemName: Constants.searchIconName)
        )
        searchViewController.tabBarItem = itemOne
        viewControllers = [searchViewController]
    }
}
