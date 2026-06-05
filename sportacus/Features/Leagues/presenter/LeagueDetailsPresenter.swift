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
        
        // We keep mock teams setup as teams fetching is excluded for now
        setupMockTeamsOnly()
        view?.displayTeams(teams)
        
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
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.upcomingEvents = fetchedUpcoming
            self.latestEvents = fetchedLatest
            
            self.view?.displayUpcomingEvents(self.upcomingEvents)
            self.view?.displayLatestEvents(self.latestEvents)
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
    
    private func setupMockTeamsOnly() {
        var teamNames: [String] = []
        switch league.leagueName.lowercased() {
        case let name where name.contains("premier"):
            teamNames = ["Arsenal", "Chelsea", "Liverpool", "Man City", "Man United", "Tottenham", "Aston Villa", "Newcastle"]
        case let name where name.contains("primera") || name.contains("liga"):
            teamNames = ["Real Madrid", "Barcelona", "Atletico Madrid", "Sevilla", "Real Sociedad", "Villarreal", "Real Betis", "Valencia"]
        case let name where name.contains("serie"):
            teamNames = ["Juventus", "AC Milan", "Inter Milan", "Napoli", "Roma", "Lazio", "Atalanta", "Fiorentina"]
        case let name where name.contains("bundesliga"):
            teamNames = ["Bayern Munich", "Dortmund", "Leverkusen", "Leipzig", "Frankfurt", "Freiburg", "Monchengladbach", "Wolfsburg"]
        default:
            teamNames = ["Team Alpha", "Team Beta", "Team Gamma", "Team Delta", "Team Epsilon", "Team Zeta", "Team Eta", "Team Theta"]
        }
        
        let sfSymbolIcons = [
            "shield.fill", "hexagon.fill", "suit.club.fill", "rhombus.fill",
            "triangle.fill", "circle.fill", "seal.fill", "star.fill"
        ]
        
        teams = teamNames.enumerated().map { index, name in
            let icon = sfSymbolIcons[index % sfSymbolIcons.count]
            return Team(teamName: name, logoName: icon)
        }
    }
}
