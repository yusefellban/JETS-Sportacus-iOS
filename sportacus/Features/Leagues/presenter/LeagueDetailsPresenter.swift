import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    weak var view: LeagueDetailsViewProtocol?
    let league: League
    private let sport: Sport
    
    private var upcomingEvents: [UpcomingEvent] = []
    private var latestEvents: [LatestEvent] = []
    private var teams: [Team] = []
    private var isFavorite: Bool = false
    
    init(view: LeagueDetailsViewProtocol, league: League, sport: Sport) {
        self.view = view
        self.league = league
        self.sport = sport
    }
    
    func viewDidLoad() {
        view?.showLoading()
        view?.displayLeagueName(league.leagueName)
        view?.showFavoriteState(isFavorite: isFavorite)
        
        // Teams will be fetched via API
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let today = Date()
        let calendar = Calendar.current
        
        guard let thirtyDaysFuture = calendar.date(byAdding: .day, value: 30, to: today),
              let thirtyDaysPast = calendar.date(byAdding: .day, value: -30, to: today) else {
            view?.hideLoading()
            return
        }
        
        let todayStr = formatter.string(from: today)
        let futureStr = formatter.string(from: thirtyDaysFuture)
        let pastStr = formatter.string(from: thirtyDaysPast)
        
        let dispatchGroup = DispatchGroup()
        
        var fetchedUpcoming: [UpcomingEvent] = []
        var fetchedLatest: [LatestEvent] = []
        var fetchedTeams: [Team] = []
        
        // 1. Fetch Upcoming Events
        dispatchGroup.enter()
        NetworkService.shared.fetchEvents(for: sport, leagueId: league.leagueKey, from: todayStr, to: futureStr) { result in
            switch result {
            case .success(let apiEvents):
                fetchedUpcoming = apiEvents.map { apiEvent in
                    UpcomingEvent(
                        eventName: "\(apiEvent.eventHomeTeam) vs \(apiEvent.eventAwayTeam)",
                        date: apiEvent.eventDate,
                        time: apiEvent.eventTime,
                        homeTeamLogo: apiEvent.homeTeamLogo ?? "",
                        awayTeamLogo: apiEvent.awayTeamLogo ?? ""
                    )
                }
            case .failure(let error):
                print("Error fetching upcoming events: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        // 2. Fetch Latest Events
        dispatchGroup.enter()
        NetworkService.shared.fetchEvents(for: sport, leagueId: league.leagueKey, from: pastStr, to: todayStr) { result in
            switch result {
            case .success(let apiEvents):
                fetchedLatest = apiEvents.map { apiEvent in
                    var homeScore = "-"
                    var awayScore = "-"
                    if let resultStr = apiEvent.eventFinalResult {
                        let parts = resultStr.components(separatedBy: " - ")
                        if parts.count == 2 {
                            homeScore = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                            awayScore = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                        } else {
                            let partsAlt = resultStr.components(separatedBy: "-")
                            if partsAlt.count == 2 {
                                homeScore = partsAlt[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                awayScore = partsAlt[1].trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                        }
                    }
                    return LatestEvent(
                        homeTeamName: apiEvent.eventHomeTeam,
                        awayTeamName: apiEvent.eventAwayTeam,
                        homeScore: homeScore,
                        awayScore: awayScore,
                        date: apiEvent.eventDate,
                        time: apiEvent.eventTime,
                        homeTeamLogo: apiEvent.homeTeamLogo ?? "",
                        awayTeamLogo: apiEvent.awayTeamLogo ?? ""
                    )
                }
            case .failure(let error):
                print("Error fetching latest events: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        // 3. Fetch Teams
        dispatchGroup.enter()
        NetworkService.shared.fetchTeams(for: sport, leagueId: league.leagueKey) { result in
            switch result {
            case .success(let apiTeams):
                fetchedTeams = apiTeams.map { apiTeam in
                    Team(teamName: apiTeam.teamName, logoName: apiTeam.teamLogo ?? "")
                }
            case .failure(let error):
                print("Error fetching teams: \(error.localizedDescription)")
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.upcomingEvents = fetchedUpcoming
            self.latestEvents = fetchedLatest
            self.teams = fetchedTeams
            
            self.view?.displayUpcomingEvents(self.upcomingEvents)
            self.view?.displayLatestEvents(self.latestEvents)
            self.view?.displayTeams(self.teams)
            self.view?.hideLoading()
        }
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        view?.showFavoriteState(isFavorite: isFavorite)
    }
    
    func selectTeam(at index: Int) {
        guard index >= 0 && index < teams.count else { return }
        let selectedTeam = teams[index]
        print("Selected team: \(selectedTeam.teamName)")
    }
    

}
