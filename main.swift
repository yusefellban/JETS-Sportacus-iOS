import Foundation

let group = DispatchGroup()
group.enter()

NetworkService.shared.fetchLeagues(for: .basketball) { result in
    switch result {
    case .success(let leagues):
        print("Integration Test Basketball Leagues: \(leagues.count)")
    case .failure(let error):
        print("Integration Test Error: \(error)")
    }
    group.leave()
}

group.wait()
