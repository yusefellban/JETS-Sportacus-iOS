//
//  SportsViewController.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import UIKit

class SportsViewController: UIViewController, SportsViewProtocol {
    
    var presenter: SportsPresenterProtocol?
    
    @IBOutlet weak var footballCard: UIView!
    @IBOutlet weak var basketballCard: UIView!
    @IBOutlet weak var cricketCard: UIView!
    @IBOutlet weak var tennisCard: UIView!
    
    // Loading indicator
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "LimeNeon") ?? .systemGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sports"
        
        setupCardStyles()
        setupLoadingIndicator()
        
        // Notify presenter that view is ready
        presenter?.viewDidLoad()
    }
    
    private func setupCardStyles() {
        let cards = [footballCard, basketballCard, cricketCard, tennisCard]
        let borderColor = UIColor(named: "LimeNeon")?.cgColor ?? UIColor.green.cgColor
        
        cards.forEach { card in
            guard let card = card else { return }
            // Rounded corners on the container card
            card.layer.cornerRadius = 16
            card.layer.borderWidth = 1.5
            card.layer.borderColor = borderColor
            card.backgroundColor = .white
            
            // Premium iOS Card shadow
            card.layer.shadowColor = UIColor.black.cgColor
            card.layer.shadowOpacity = 0.1
            card.layer.shadowOffset = CGSize(width: 0, height: 4)
            card.layer.shadowRadius = 6
            card.layer.masksToBounds = false
            
            // Round the corners of the subviews (image and title container)
            if card.subviews.count >= 2 {
                let imgView = card.subviews[0]
                let titleView = card.subviews[1]
                
                // Round top corners of the image
                imgView.clipsToBounds = true
                imgView.layer.cornerRadius = 16
                imgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                
                // Round bottom corners of the title container
                titleView.clipsToBounds = true
                titleView.layer.cornerRadius = 16
                titleView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - IBActions for grid buttons
    
    @IBAction func footballTapped(_ sender: UIButton) {
        presenter?.selectSport(at: 0)
    }
    
    @IBAction func basketballTapped(_ sender: UIButton) {
        presenter?.selectSport(at: 1)
    }
    
    @IBAction func cricketTapped(_ sender: UIButton) {
        presenter?.selectSport(at: 2)
    }
    
    @IBAction func tennisTapped(_ sender: UIButton) {
        presenter?.selectSport(at: 3)
    }
    
    // MARK: - SportsViewProtocol
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displaySports(_ sports: [Sport]) {
        // Dynamic array update not strictly required since it is a static layout,
        // but presenter logic is maintained.
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToLeagues(for sport: Sport) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesTableViewController") as? LeaguesTableViewController else { return }
        let leaguesPresenter = LeaguesPresenter(view: leaguesVC, sport: sport)
        leaguesVC.presenter = leaguesPresenter
        navigationController?.pushViewController(leaguesVC, animated: true)
    }
}
