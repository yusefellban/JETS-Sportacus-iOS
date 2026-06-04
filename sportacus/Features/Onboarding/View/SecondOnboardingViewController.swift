//
//  SecondOnboardingViewController.swift
//  sportacus
//
//  Created by Ashraf on 04/06/2026.
//

import UIKit

class SecondOnboardingViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.layer.cornerRadius = 20
            containerView.clipsToBounds = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
