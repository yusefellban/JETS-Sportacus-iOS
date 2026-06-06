//
//  LeaguesPresenter.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    weak var view: LeaguesViewProtocol?
    
    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []
    private let sport: Sport
    
    init(view: LeaguesViewProtocol, sport: Sport) {
        self.view = view
        self.sport = sport
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        NetworkService.shared.fetchLeagues(for: sport) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideLoading()
                switch result {
                case .success(let leagues):
                    self.allLeagues = leagues
                    self.filteredLeagues = leagues
                    self.view?.displayLeagues(self.filteredLeagues)
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func searchLeagues(with query: String) {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            filteredLeagues = allLeagues
        } else {
            filteredLeagues = allLeagues.filter { league in
                league.leagueName.lowercased().contains(query.lowercased()) ||
                league.countryName.lowercased().contains(query.lowercased())
            }
        }
        view?.displayLeagues(filteredLeagues)
    }
    
    func selectLeague(at index: Int) {
        guard index >= 0 && index < filteredLeagues.count else { return }
        let selectedLeague = filteredLeagues[index]
        view?.navigateToLeagueDetails(for: selectedLeague, sport: sport)
    }
    
    var numberOfLeagues: Int {
        return filteredLeagues.count
    }
    
    func league(at index: Int) -> League {
        return filteredLeagues[index]
    }
    
    func isFavorite(league: League) -> Bool {
        return FavoritesManager.shared.isFavorite(league)
    }
    
    func toggleFavorite(at index: Int) {
        guard index >= 0 && index < filteredLeagues.count else { return }
        let selectedLeague = filteredLeagues[index]
        if FavoritesManager.shared.isFavorite(selectedLeague) {
            FavoritesManager.shared.removeFromFavorites(selectedLeague)
        } else {
            FavoritesManager.shared.addToFavorites(selectedLeague, sport: sport)
        }
        view?.displayLeagues(filteredLeagues)
    }
}
