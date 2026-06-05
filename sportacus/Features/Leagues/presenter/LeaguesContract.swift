//
//  LeaguesContract.swift
//  sportacus
//
//  Created by Noureldeen on 03/06/2026.
//

import Foundation

protocol LeaguesViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayLeagues(_ leagues: [League])
    func showError(_ message: String)
    func navigateToLeagueDetails(for league: League, sport: Sport)
}

protocol LeaguesPresenterProtocol: AnyObject {
    var view: LeaguesViewProtocol? { get set }
    func viewDidLoad()
    func searchLeagues(with query: String)
    func selectLeague(at index: Int)
    
    var numberOfLeagues: Int { get }
    func league(at index: Int) -> League
    func isFavorite(league: League) -> Bool
    func toggleFavorite(at index: Int)
}
