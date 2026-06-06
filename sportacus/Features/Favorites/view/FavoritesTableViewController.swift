//
//  FavoritesTableViewController.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import UIKit

class FavoritesTableViewController: UITableViewController, FavoritesViewProtocol, UISearchBarDelegate {
    
    var presenter: FavoritesPresenterProtocol?
    
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
        title = "Favorite"
        
        setupTableView()
        setupLoadingIndicator()
        
        searchBar.delegate = self
        
        // Notify presenter to load favorites
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload favorites from CoreData every time the tab appears
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: LeagueTableViewCell.reuseIdentifier, for: indexPath) as! LeagueTableViewCell
        if let leagueItem = presenter?.favorite(at: indexPath.row) {
            cell.configure(with: leagueItem, isFavorite: true, isFavoritesScreen: true)
            cell.onActionTapped = { [weak self] in
                self?.confirmDeletion(at: indexPath)
            }
        }
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96 // Match the 80 height + 16 padding card design
    }
    
    private func confirmDeletion(at indexPath: IndexPath) {
        guard let leagueItem = presenter?.favorite(at: indexPath.row) else { return }
        
        let alert = UIAlertController(
            title: "Delete Favorite",
            message: "Are you sure you want to remove '\(leagueItem.leagueName)' from your favorites?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.presenter?.deleteFavorite(at: indexPath.row)
        })
        
        present(alert, animated: true)
    }
}
