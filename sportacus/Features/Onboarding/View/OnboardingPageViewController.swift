//
//  OnboardingPageViewController.swift
//  sportacus
//
//  Created by Ashraf on 04/06/2026.
//

import UIKit

class OnboardingPageViewController: UIPageViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    var arrContainer  = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        // Do any additional setup after loading the view.
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "v1")
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "v2")
        let v3 = self.storyboard?.instantiateViewController(withIdentifier: "v3")
        arrContainer.append(v1!)
        arrContainer.append(v2!)
        arrContainer.append(v3!)
        
        if let v1 = arrContainer.first{
            setViewControllers([v1], direction: .forward, animated: true,completion: nil)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndx = arrContainer.firstIndex(of: viewController) else {
            return nil
        }
        let prev = currentIndx - 1
        guard prev >= 0 else {
            return nil
        }
        return arrContainer[prev]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndx = arrContainer.firstIndex(of: viewController) else {
            return nil
        }
        let next = currentIndx + 1
        guard next < arrContainer.count else {
            return nil
        }
        return arrContainer[next]
    }

}
