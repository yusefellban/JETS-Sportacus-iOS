import Foundation

let group = DispatchGroup()

group.enter()
NetworkService.shared.fetchEvents(for: .tennis, leagueId: 2646, from: "2025-06-15", to: "2027-06-15") { result in
    switch result {
    case .success(let events):
        print("Integration Test Tennis Events (Fixtures) with 365 days: \(events.count)")
        if let first = events.first {
            print("First Event: \(first.eventHomeTeam) vs \(first.eventAwayTeam)")
        }
    case .failure(let error):
        print("Integration Test Events Error: \(error)")
    }
    group.leave()
}

group.wait()
