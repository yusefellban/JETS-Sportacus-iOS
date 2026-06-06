//
//  NetworkService.swift
//  sportacus
//
//  Created by Noureldeen on 05/06/2026.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchLeagues(for sport: Sport, completion: @escaping (Result<[League], Error>) -> Void) {
        let urlString = "\(APIConstants.baseUrl)/\(sport.rawValue)/?met=Leagues&APIkey=\(APIConstants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL structure"])
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NetworkService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received from API"])
                completion(.failure(error))
                return
            }
            
            do {
                let responseObj = try JSONDecoder().decode(LeaguesResponse.self, from: data)
                if responseObj.success == 1 {
                    let leagues = responseObj.result ?? []
                    completion(.success(leagues))
                } else {
                    let error = NSError(domain: "NetworkService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch leagues from API"])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchEvents(for sport: Sport, leagueId: Int64, from: String, to: String, completion: @escaping (Result<[APIEvent], Error>) -> Void) {
        let urlString = "\(APIConstants.baseUrl)/\(sport.rawValue)/?met=Fixtures&leagueId=\(leagueId)&from=\(from)&to=\(to)&APIkey=\(APIConstants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL structure"])
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NetworkService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received from API"])
                completion(.failure(error))
                return
            }
            
            do {
                let responseObj = try JSONDecoder().decode(EventResponse.self, from: data)
                if responseObj.success == 1 {
                    let events = responseObj.result ?? []
                    completion(.success(events))
                } else {
                    // AllSportsAPI returns success = 0 if there are no events in the given range.
                    // This is not necessarily a hard network failure, so we can return an empty array.
                    completion(.success([]))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchTeams(for sport: Sport, leagueId: Int64, completion: @escaping (Result<[APITeam], Error>) -> Void) {
        let urlString = "\(APIConstants.baseUrl)/\(sport.rawValue)/?met=Teams&leagueId=\(leagueId)&APIkey=\(APIConstants.apiKey)"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "NetworkService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL structure"])
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NetworkService", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received from API"])
                completion(.failure(error))
                return
            }
            
            do {
                let responseObj = try JSONDecoder().decode(TeamsResponse.self, from: data)
                if responseObj.success == 1 {
                    let teams = responseObj.result ?? []
                    completion(.success(teams))
                } else {
                    completion(.success([]))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

// MARK: - API Team Models

struct TeamsResponse: Codable {
    let success: Int
    let result: [APITeam]?
    
    enum CodingKeys: String, CodingKey {
        case success
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let successInt = try? container.decode(Int.self, forKey: .success) {
            success = successInt
        } else if let successStr = try? container.decode(String.self, forKey: .success), let successInt = Int(successStr) {
            success = successInt
        } else {
            success = 0
        }
        
        if let array = try? container.decode([APITeam].self, forKey: .result) {
            result = array
        } else {
            result = nil
        }
    }
}

struct APITeam: Codable {
    let teamKey: Int64
    let teamName: String
    let teamLogo: String?
    let players: [APIPlayer]?
    let coaches: [APICoach]?
    
    enum CodingKeys: String, CodingKey {
        case teamKey = "team_key"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case players = "players"
        case coaches = "coaches"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode teamKey safely
        if let keyInt = try? container.decode(Int64.self, forKey: .teamKey) {
            teamKey = keyInt
        } else if let keyInt = try? container.decode(Int.self, forKey: .teamKey) {
            teamKey = Int64(keyInt)
        } else if let keyString = try? container.decode(String.self, forKey: .teamKey), let keyInt = Int64(keyString) {
            teamKey = keyInt
        } else {
            teamKey = 0
        }
        
        teamName = (try? container.decode(String.self, forKey: .teamName)) ?? "Unknown Team"
        teamLogo = try? container.decodeIfPresent(String.self, forKey: .teamLogo)
        players = try? container.decodeIfPresent([APIPlayer].self, forKey: .players)
        coaches = try? container.decodeIfPresent([APICoach].self, forKey: .coaches)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(teamKey, forKey: .teamKey)
        try container.encode(teamName, forKey: .teamName)
        try container.encode(teamLogo, forKey: .teamLogo)
        try container.encode(players, forKey: .players)
        try container.encode(coaches, forKey: .coaches)
    }
}

struct APIPlayer: Codable {
    let playerName: String?
    let playerType: String?
    
    enum CodingKeys: String, CodingKey {
        case playerName = "player_name"
        case playerType = "player_type"
    }
}

struct APICoach: Codable {
    let coachName: String?
    
    enum CodingKeys: String, CodingKey {
        case coachName = "coach_name"
    }
}
