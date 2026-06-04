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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

}
