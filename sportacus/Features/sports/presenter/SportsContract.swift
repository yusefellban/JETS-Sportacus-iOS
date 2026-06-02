//
//  SportsContract.swift
//  sportacus
//
//  Created by Noureldeen on 02/06/2026.
//

import Foundation

protocol SportsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displaySports(_ sports: [Sport])
    func showError(_ message: String)
    func navigateToLeagues(for sport: Sport)
}

protocol SportsPresenterProtocol: AnyObject {
    var view: SportsViewProtocol? { get set }
    func viewDidLoad()
    func selectSport(at index: Int)
}
