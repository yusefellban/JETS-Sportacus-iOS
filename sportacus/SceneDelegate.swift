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
        self.window = window
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if CoreDataManager.shared.isOnboardingCompleted() {
            // Onboarding already done — go straight to main app
            guard let tabBarController = storyboard.instantiateViewController(
                withIdentifier: "TabBarController"
            ) as? UITabBarController else {
                window.makeKeyAndVisible()
                return
            }
            
            // Wire up Sports presenter
            if let sportsNav = tabBarController.viewControllers?[0] as? UINavigationController,
               let sportsVC = sportsNav.topViewController as? SportsViewController {
                let presenter = SportsPresenter(view: sportsVC)
                sportsVC.presenter = presenter
            }
            
            // Wire up Favorites presenter
            if let favNav = tabBarController.viewControllers?[1] as? UINavigationController,
               let favVC = favNav.topViewController as? FavoritesTableViewController {
                let presenter = FavoritesPresenter(view: favVC)
                favVC.presenter = presenter
            }
            
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
        } else {
            // First launch — show onboarding
            guard let onboardingVC = storyboard.instantiateViewController(
                withIdentifier: "OnboardingPageViewController"
            ) as? OnboardingPageViewController else {
                window.makeKeyAndVisible()
                return
            }
            window.rootViewController = onboardingVC
        }
        
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

