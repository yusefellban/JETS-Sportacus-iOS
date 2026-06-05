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
}
