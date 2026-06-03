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
            card.layer.cornerRadius = 24
            card.layer.masksToBounds = true
            card.layer.borderWidth = 1.5
            card.layer.borderColor = borderColor
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
        let leaguesPresenter = LeaguesPresenter(view: leaguesVC)
        leaguesVC.presenter = leaguesPresenter
        navigationController?.pushViewController(leaguesVC, animated: true)
    }
}
