//
//  SportsPresenter.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import Foundation

class SportsPresenter: SportsPresenterProtocol {
    weak var view: SportsViewProtocol?
    private var sports: [Sport] = []
    
    init(view: SportsViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        // Load the 4 sports categories
        self.sports = Sport.allCases
        view?.hideLoading()
        view?.displaySports(sports)
    }
    
    func selectSport(at index: Int) {
        guard index >= 0 && index < sports.count else { return }
        let selectedSport = sports[index]
        view?.navigateToLeagues(for: selectedSport)
    }
}
