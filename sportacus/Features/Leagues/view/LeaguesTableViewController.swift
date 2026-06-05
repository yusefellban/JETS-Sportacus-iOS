//
//  LeaguesTableViewController.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import UIKit

class LeaguesTableViewController: UITableViewController, LeaguesViewProtocol, UISearchBarDelegate {
    
    var presenter: LeaguesPresenterProtocol?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor(named: "LimeNeon") ?? .systemGreen
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Leagues"
        
        setupTableView()
        setupLoadingIndicator()
        
        searchBar.delegate = self
        
        // Notify presenter to load data
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        // Soft gray background color for a premium look under Light Mode
        tableView.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        tableView.separatorStyle = .none
    }
    
    private func setupLoadingIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - LeaguesViewProtocol
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayLeagues(_ leagues: [League]) {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func navigateToLeagueDetails(for league: League, sport: Sport) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailsVC = storyboard.instantiateViewController(withIdentifier: "LeagueDetailsViewController") as? LeagueDetailsViewController {
            let detailsPresenter = LeagueDetailsPresenter(view: detailsVC, league: league, sport: sport)
            detailsVC.presenter = detailsPresenter
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchLeagues(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfLeagues ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueTableViewCell.reuseIdentifier, for: indexPath) as! LeagueTableViewCell
        if let leagueItem = presenter?.league(at: indexPath.row) {
            let isFav = presenter?.isFavorite(league: leagueItem) ?? false
            cell.configure(with: leagueItem, isFavorite: isFav, isFavoritesScreen: false)
            cell.onActionTapped = { [weak self] in
                self?.presenter?.toggleFavorite(at: indexPath.row)
            }
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96 // 80 content height + 16 margin padding
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.selectLeague(at: indexPath.row)
    }
}
