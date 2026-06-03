import Foundation

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    weak var view: LeagueDetailsViewProtocol?
    let league: League
    
    private var upcomingEvents: [UpcomingEvent] = []
    private var latestEvents: [LatestEvent] = []
    private var teams: [Team] = []
    private var isFavorite: Bool = false
    
    init(view: LeagueDetailsViewProtocol, league: League) {
        self.view = view
        self.league = league
    }
    
    func viewDidLoad() {
        view?.showLoading()
        view?.displayLeagueName(league.leagueName)
        
        // Mock data setup based on the selected league
        setupMockData()
        
        view?.displayUpcomingEvents(upcomingEvents)
        view?.displayLatestEvents(latestEvents)
        view?.displayTeams(teams)
        view?.showFavoriteState(isFavorite: isFavorite)
        view?.hideLoading()
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
    
    private func setupMockData() {
        // Define team names based on league
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
        
        // Team logos using SF symbols for a beautiful look without relying on asset files
        let sfSymbolIcons = [
            "shield.fill", "hexagon.fill", "suit.club.fill", "rhombus.fill",
            "triangle.fill", "circle.fill", "seal.fill", "star.fill"
        ]
        
        // Populate Teams
        teams = teamNames.enumerated().map { index, name in
            let icon = sfSymbolIcons[index % sfSymbolIcons.count]
            return Team(teamName: name, logoName: icon)
        }
        
        // Populate Upcoming Events
        upcomingEvents = [
            UpcomingEvent(
                eventName: "\(teams[0].teamName) vs \(teams[1].teamName)",
                date: "2026-06-12",
                time: "20:00",
                homeTeamLogo: teams[0].logoName,
                awayTeamLogo: teams[1].logoName
            ),
            UpcomingEvent(
                eventName: "\(teams[2].teamName) vs \(teams[3].teamName)",
                date: "2026-06-15",
                time: "18:30",
                homeTeamLogo: teams[2].logoName,
                awayTeamLogo: teams[3].logoName
            ),
            UpcomingEvent(
                eventName: "\(teams[4].teamName) vs \(teams[5].teamName)",
                date: "2026-06-18",
                time: "21:00",
                homeTeamLogo: teams[4].logoName,
                awayTeamLogo: teams[5].logoName
            ),
            UpcomingEvent(
                eventName: "\(teams[6].teamName) vs \(teams[7].teamName)",
                date: "2026-06-20",
                time: "16:00",
                homeTeamLogo: teams[6].logoName,
                awayTeamLogo: teams[7].logoName
            )
        ]
        
        // Populate Latest Events
        latestEvents = [
            LatestEvent(
                homeTeamName: teams[1].teamName,
                awayTeamName: teams[2].teamName,
                homeScore: "2",
                awayScore: "1",
                date: "2026-05-30",
                time: "17:30",
                homeTeamLogo: teams[1].logoName,
                awayTeamLogo: teams[2].logoName
            ),
            LatestEvent(
                homeTeamName: teams[3].teamName,
                awayTeamName: teams[0].teamName,
                homeScore: "0",
                awayScore: "3",
                date: "2026-05-28",
                time: "21:00",
                homeTeamLogo: teams[3].logoName,
                awayTeamLogo: teams[0].logoName
            ),
            LatestEvent(
                homeTeamName: teams[5].teamName,
                awayTeamName: teams[4].teamName,
                homeScore: "2",
                awayScore: "2",
                date: "2026-05-25",
                time: "19:00",
                homeTeamLogo: teams[5].logoName,
                awayTeamLogo: teams[4].logoName
            ),
            LatestEvent(
                homeTeamName: teams[7].teamName,
                awayTeamName: teams[6].teamName,
                homeScore: "1",
                awayScore: "0",
                date: "2026-05-22",
                time: "15:00",
                homeTeamLogo: teams[7].logoName,
                awayTeamLogo: teams[6].logoName
            )
        ]
    }
}
