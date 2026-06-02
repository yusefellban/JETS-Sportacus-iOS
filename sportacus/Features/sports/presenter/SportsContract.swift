import Foundation

protocol SportsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displaySports(_ sports: [Sport])
    func showError(_ message: String)
}

protocol SportsPresenterProtocol: AnyObject {
    var view: SportsViewProtocol? { get set }
    func viewDidLoad()
    func selectSport(at index: Int)
}
