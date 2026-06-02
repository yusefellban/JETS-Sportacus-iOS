//
//  FavoritesTableViewController.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import UIKit

class FavoritesTableViewController: UITableViewController, FavoritesViewProtocol, UISearchBarDelegate {
    
    var presenter: FavoritesPresenterProtocol?
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search Favorite Leagues"
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
        title = "Favorite"
        
        setupTableView()
        setupSearchBar()
        setupLoadingIndicator()
        
        // Notify presenter to load favorites
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        tableView.backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 250/255, alpha: 1.0)
        tableView.separatorStyle = .none
        tableView.register(LeagueTableViewCell.self, forCellReuseIdentifier: LeagueTableViewCell.reuseIdentifier)
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
    
    // MARK: - FavoritesViewProtocol
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
    
    func displayFavorites(_ favorites: [League]) {
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchFavorites(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfFavorites ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withReuseIdentifier: LeagueTableViewCell.reuseIdentifier, for: indexPath) as! LeagueTableViewCell
        if let leagueItem = presenter?.favorite(at: indexPath.row) {
            cell.configure(with: leagueItem)
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96 // Match the 80 height + 16 padding card design
    }
    
    // MARK: - Swipe to Delete with Alert Confirmation
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.confirmDeletion(at: indexPath, completion: completionHandler)
        }
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    private func confirmDeletion(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        guard let leagueItem = presenter?.favorite(at: indexPath.row) else {
            completion(false)
            return
        }
        
        let alert = UIAlertController(
            title: "Delete Favorite",
            message: "Are you sure you want to remove '\(leagueItem.leagueName)' from your favorites?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        })
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter?.deleteFavorite(at: indexPath.row)
            completion(true)
        })
        
        present(alert, animated: true)
    }
}
