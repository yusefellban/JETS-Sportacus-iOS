import Foundation

// MARK: - View Models
struct UpcomingEvent {
    let eventName: String      // corresponds to strEvent
    let date: String           // event date
    let time: String           // event time
    let homeTeamLogo: String   // image name or URL
    let awayTeamLogo: String   // image name or URL
}

struct LatestEvent {
    let homeTeamName: String   // homeTeam name
    let awayTeamName: String   // awayTeam name
    let homeScore: String      // intHomeScore
    let awayScore: String      // intAwayScore/second score
    let date: String
    let time: String
    let homeTeamLogo: String
    let awayTeamLogo: String
}

struct Team {
    let teamName: String
    let logoName: String
}

// MARK: - MVP Protocols
protocol LeagueDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayLeagueName(_ name: String)
    func displayUpcomingEvents(_ events: [UpcomingEvent])
    func displayLatestEvents(_ events: [LatestEvent])
    func displayTeams(_ teams: [Team])
    func showFavoriteState(isFavorite: Bool)
}

protocol LeagueDetailsPresenterProtocol: AnyObject {
    var view: LeagueDetailsViewProtocol? { get set }
    var league: League { get }
    
    func viewDidLoad()
    func toggleFavorite()
    func selectTeam(at index: Int)
}
