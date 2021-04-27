//
//  TabBarViewController.swift
//  whatToWatch
//
//  Created by Maksim Lipenko on 27.04.21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dashboardVC = DashboardViewController()
        let searchVC = SearchViewController()
        let profile = ProfileViewController()
        
        dashboardVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: dashboardVC)
        let nav2 = UINavigationController(rootViewController: searchVC)
        let nav3 = UINavigationController(rootViewController: profile)
        
        nav1.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "tv"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3], animated: false)
    }
}
