//
//  FavoritesPresenter.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import Foundation

class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var view: FavoritesViewProtocol?
    
    private var allFavorites: [League] = []
    private var filteredFavorites: [League] = []
    
    init(view: FavoritesViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        // Mock favorites matching the user's screenshot
        allFavorites = [
            League(leagueKey: 3, leagueName: "Premier League", leagueLogo: "premier_league", countryName: "England"),
            League(leagueKey: 7, leagueName: "Premier League", leagueLogo: nil, countryName: "Egypt"),
            League(leagueKey: 8, leagueName: "Pro League", leagueLogo: nil, countryName: "Belgium")
        ]
        
        filteredFavorites = allFavorites
        
        view?.hideLoading()
        view?.displayFavorites(filteredFavorites)
    }
    
    func searchFavorites(with query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredFavorites = allFavorites
        } else {
            filteredFavorites = allFavorites.filter { league in
                league.leagueName.lowercased().contains(query.lowercased()) ||
                league.countryName.lowercased().contains(query.lowercased())
            }
        }
        view?.displayFavorites(filteredFavorites)
    }
    
    func deleteFavorite(at index: Int) {
        guard index >= 0 && index < filteredFavorites.count else { return }
        let deletedItem = filteredFavorites[index]
        
        // Remove from filtered list
        filteredFavorites.remove(at: index)
        
        // Remove from master list
        if let masterIndex = allFavorites.firstIndex(where: { $0.leagueKey == deletedItem.leagueKey }) {
            allFavorites.remove(at: masterIndex)
        }
        
        view?.displayFavorites(filteredFavorites)
    }
    
    var numberOfFavorites: Int {
        return filteredFavorites.count
    }
    
    func favorite(at index: Int) -> League {
        return filteredFavorites[index]
    }
}
