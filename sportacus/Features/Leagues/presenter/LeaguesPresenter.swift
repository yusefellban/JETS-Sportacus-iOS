import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    weak var view: LeaguesViewProtocol?
    
    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []
    
    init(view: LeaguesViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        // Populate dummy data based on user image categories
        allLeagues = [
            League(leagueKey: 1, leagueName: "UEFA Nations League", leagueLogo: "uefa_nations_league", countryName: "eurocups"),
            League(leagueKey: 2, leagueName: "World Cup", leagueLogo: "world_cup", countryName: "Worldcup"),
            League(leagueKey: 3, leagueName: "Premier League", leagueLogo: "premier_league", countryName: "England"),
            League(leagueKey: 4, leagueName: "Primera", leagueLogo: "la_liga", countryName: "Spain"),
            League(leagueKey: 5, leagueName: "Serie A", leagueLogo: "serie_a", countryName: "Italy"),
            League(leagueKey: 6, leagueName: "Bundesliga", leagueLogo: "bundesliga", countryName: "Germany")
        ]
        
        filteredLeagues = allLeagues
        
        view?.hideLoading()
        view?.displayLeagues(filteredLeagues)
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
        print("Selected league: \(selectedLeague.leagueName)")
    }
    
    var numberOfLeagues: Int {
        return filteredLeagues.count
    }
    
    func league(at index: Int) -> League {
        return filteredLeagues[index]
    }
}
