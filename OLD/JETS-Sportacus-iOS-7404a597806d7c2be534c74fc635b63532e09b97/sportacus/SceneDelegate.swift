//
//  SceneDelegate.swift
//  sportacus
//
//  Created by Ashraf on 02/06/2026.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // 1. Create Sports VC with grid flow layout
        let layout = UICollectionViewFlowLayout()
        let sportsVC = SportsViewController(collectionViewLayout: layout)
        let sportsPresenter = SportsPresenter(view: sportsVC)
        sportsVC.presenter = sportsPresenter
        
        let sportsNav = UINavigationController(rootViewController: sportsVC)
        sportsNav.tabBarItem = UITabBarItem(title: "Sports", image: UIImage(systemName: "sportscourt"), selectedImage: UIImage(systemName: "sportscourt.fill"))
        
        // 2. Create Favorites VC
        let favoritesVC = FavoritesTableViewController()
        let favoritesPresenter = FavoritesPresenter(view: favoritesVC)
        favoritesVC.presenter = favoritesPresenter
        
        let favoritesNav = UINavigationController(rootViewController: favoritesVC)
        favoritesNav.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        // 3. Create TabBarController
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [sportsNav, favoritesNav]
        
        // Customize tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(named: "DeepForestNight") ?? .systemBackground
        
        tabBarController.tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBarController.tabBar.scrollEdgeAppearance = appearance
        }
        tabBarController.tabBar.tintColor = UIColor(named: "LimeNeon") ?? .systemGreen
        tabBarController.tabBar.unselectedItemTintColor = .lightGray
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

