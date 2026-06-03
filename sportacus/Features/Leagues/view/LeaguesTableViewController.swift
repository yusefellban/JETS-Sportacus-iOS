//
//  LeaguesTableViewController.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import UIKit

class LeaguesTableViewController: UITableViewController, LeaguesViewProtocol, UISearchBarDelegate {
    
    var presenter: LeaguesPresenterProtocol?
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search Leagues"
        sb.searchBarStyle = .minimal
        sb.backgroundColor = .clear
        return sb
    }()
    
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
        setupSearchBar()
        setupLoadingIndicator()
        
        // Notify presenter to load data
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        // Soft gray background color for a premium look under Light Mode
        tableView.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        tableView.separatorStyle = .none
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 60))
        searchBar.frame = CGRect(x: 8, y: 0, width: view.bounds.width - 16, height: 60)
        searchBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerView.addSubview(searchBar)
        
        tableView.tableHeaderView = headerView
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
    
    func navigateToLeagueDetails(for league: League) {
        let detailsVC = LeagueDetailsViewController()
        let detailsPresenter = LeagueDetailsPresenter(view: detailsVC, league: league)
        detailsVC.presenter = detailsPresenter
        navigationController?.pushViewController(detailsVC, animated: true)
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
            cell.configure(with: leagueItem)
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
