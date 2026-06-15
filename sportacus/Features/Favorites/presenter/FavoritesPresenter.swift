//
//  FavoritesPresenter.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import Foundation

class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var view: FavoritesViewProtocol?
    
    private var filteredFavorites: [League] = []
    
    init(view: FavoritesViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        filteredFavorites = FavoritesManager.shared.favorites
        view?.hideLoading()
        view?.displayFavorites(filteredFavorites)
    }
    
    func searchFavorites(with query: String) {
        let allFavorites = FavoritesManager.shared.favorites
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
        
        FavoritesManager.shared.removeFromFavorites(deletedItem)
        filteredFavorites.remove(at: index)
        
        view?.displayFavorites(filteredFavorites)
    }
    
    var numberOfFavorites: Int {
        return filteredFavorites.count
    }
    
    func favorite(at index: Int) -> League {
        return filteredFavorites[index]
    }
    
    func selectFavorite(at index: Int) {
        guard index >= 0 && index < filteredFavorites.count else { return }
        
        if NetworkMonitor.shared.isConnected {
            let league = filteredFavorites[index]
            // Get sportName from CoreData to reconstruct Sport enum
            let favourites = CoreDataManager.shared.fetchAllFavourites()
            let sportName = favourites.first(where: { $0.leagueKey == league.leagueKey })?.sportName ?? "football"
            let sport = Sport(rawValue: sportName) ?? .football
            
            view?.navigateToLeagueDetails(for: league, sport: sport)
        } else {
            view?.showNoInternetAlert()
        }
    }
    
    func getSport(for league: League) -> Sport? {
        let favourites = CoreDataManager.shared.fetchAllFavourites()
        if let sportName = favourites.first(where: { $0.leagueKey == league.leagueKey })?.sportName {
            return Sport(rawValue: sportName)
        }
        return nil
    }
}

// MARK: - FavoritesManager CoreData-Backed Singleton
class FavoritesManager {
    static let shared = FavoritesManager()
    
    var favorites: [League] {
        return CoreDataManager.shared.fetchAllFavourites().map { entity in
            League(
                leagueKey: entity.leagueKey,
                leagueName: entity.leagueName ?? "",
                leagueLogo: entity.leagueLogo,
                countryName: entity.countryName ?? ""
            )
        }
    }
    
    func isFavorite(_ league: League) -> Bool {
        return CoreDataManager.shared.isFavourite(leagueKey: league.leagueKey)
    }
    
    func addToFavorites(_ league: League, sport: Sport) {
        CoreDataManager.shared.addFavourite(league: league, sport: sport)
    }
    
    func removeFromFavorites(_ league: League) {
        CoreDataManager.shared.removeFavourite(leagueKey: league.leagueKey)
    }
}

