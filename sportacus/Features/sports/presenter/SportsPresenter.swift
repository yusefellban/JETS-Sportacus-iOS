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
        print("Selected sport: \(selectedSport.displayName)")
        // In the actual app flow, this will trigger navigation to LeaguesTableViewController
    }
}
