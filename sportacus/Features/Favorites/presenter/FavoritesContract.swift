//
//  FavoritesContract.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayFavorites(_ favorites: [League])
    func showError(_ message: String)
    func navigateToLeagueDetails(for league: League, sport: Sport)
    func showNoInternetAlert()
}

protocol FavoritesPresenterProtocol: AnyObject {
    var view: FavoritesViewProtocol? { get set }
    func viewDidLoad()
    func searchFavorites(with query: String)
    func deleteFavorite(at index: Int)
    
    var numberOfFavorites: Int { get }
    func favorite(at index: Int) -> League
    func selectFavorite(at index: Int)
}
