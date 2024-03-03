//
//  TabBarViewController.swift
//  PinSoft-Task
//
//  Created by Okan Orkun on 29.02.2024.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setTabs()
    }
    
}

private extension TabBarViewController {
    private func setTabs() {
        let homeVC = generateTab(on: HomeScreenViewController(), image: SystemImages.house.normal.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal), selectedImage: SystemImages.house.toSelected.withTintColor(.label, renderingMode: .alwaysOriginal))
        
        let favoriteVC = generateTab(on: FavoriteScreenViewController(), image: SystemImages.favorite.normal.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal), selectedImage: SystemImages.favorite.toSelected.withTintColor(.label, renderingMode: .alwaysOriginal))
        
        setViewControllers([homeVC, favoriteVC], animated: true)
    }
    
    private func generateTab(on view: UIViewController, image: UIImage, selectedImage: UIImage) -> UINavigationController {
        let nav = UINavigationController(rootViewController: view)
        nav.tabBarItem = UITabBarItem(title: "", image: image, selectedImage: selectedImage)
        return nav
    }
}
