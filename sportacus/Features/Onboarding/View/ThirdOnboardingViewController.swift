//
//  ThirdOnboardingViewController.swift
//  sportacus
//
//  Created by Ashraf on 04/06/2026.
//

import UIKit

class ThirdOnboardingViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var innerContainer: UIView!
    
    
    @IBOutlet weak var getStarterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.layer.cornerRadius = 20
            containerView.clipsToBounds = true
        innerContainer.layer.cornerRadius = 20
        innerContainer.clipsToBounds = true
    }
    

    @IBAction func getStartedAction(_ sender: Any) {
        // Mark onboarding as completed in Core Data
        CoreDataManager.shared.setOnboardingCompleted()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController else { return }
        
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
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

}
