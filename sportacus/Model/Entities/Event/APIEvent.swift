//
//  APIEvent.swift
//  sportacus
//
//  Created by Noureldeen on 05/06/2026.
//

import Foundation

struct APIEvent: Codable {
    let eventKey: Int64
    let eventHomeTeam: String
    let eventAwayTeam: String
    let eventDate: String
    let eventTime: String
    let eventFinalResult: String?
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case eventDate = "event_date"
        case eventTime = "event_time"
        case eventFinalResult = "event_final_result"
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventHomeTeamLogo = "event_home_team_logo"
        case eventAwayTeamLogo = "event_away_team_logo"
        
        // Tennis specific keys
        case eventFirstPlayer = "event_first_player"
        case eventSecondPlayer = "event_second_player"
        case eventFirstPlayerLogo = "event_first_player_logo"
        case eventSecondPlayerLogo = "event_second_player_logo"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode eventKey safely
        if let keyInt = try? container.decode(Int64.self, forKey: .eventKey) {
            eventKey = keyInt
        } else if let keyInt = try? container.decode(Int.self, forKey: .eventKey) {
            eventKey = Int64(keyInt)
        } else if let keyString = try? container.decode(String.self, forKey: .eventKey), let keyInt = Int64(keyString) {
            eventKey = keyInt
        } else {
            eventKey = 0
        }
        
        let hTeam = try? container.decodeIfPresent(String.self, forKey: .eventHomeTeam)
        let fPlayer = try? container.decodeIfPresent(String.self, forKey: .eventFirstPlayer)
        eventHomeTeam = hTeam ?? fPlayer ?? "Home Team"
        
        let aTeam = try? container.decodeIfPresent(String.self, forKey: .eventAwayTeam)
        let sPlayer = try? container.decodeIfPresent(String.self, forKey: .eventSecondPlayer)
        eventAwayTeam = aTeam ?? sPlayer ?? "Away Team"
        
        eventDate = (try? container.decode(String.self, forKey: .eventDate)) ?? ""
        eventTime = (try? container.decode(String.self, forKey: .eventTime)) ?? ""
        eventFinalResult = try? container.decodeIfPresent(String.self, forKey: .eventFinalResult)
        
        // Try home_team_logo first, then event_home_team_logo, then event_first_player_logo
        let primaryHomeLogo = try? container.decodeIfPresent(String.self, forKey: .homeTeamLogo)
        let secondaryHomeLogo = try? container.decodeIfPresent(String.self, forKey: .eventHomeTeamLogo)
        let firstPlayerLogo = try? container.decodeIfPresent(String.self, forKey: .eventFirstPlayerLogo)
        homeTeamLogo = primaryHomeLogo ?? secondaryHomeLogo ?? firstPlayerLogo
        
        // Try away_team_logo first, then event_away_team_logo, then event_second_player_logo
        let primaryAwayLogo = try? container.decodeIfPresent(String.self, forKey: .awayTeamLogo)
        let secondaryAwayLogo = try? container.decodeIfPresent(String.self, forKey: .eventAwayTeamLogo)
        let secondPlayerLogo = try? container.decodeIfPresent(String.self, forKey: .eventSecondPlayerLogo)
        awayTeamLogo = primaryAwayLogo ?? secondaryAwayLogo ?? secondPlayerLogo
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(eventKey, forKey: .eventKey)
        try container.encode(eventHomeTeam, forKey: .eventHomeTeam)
        try container.encode(eventAwayTeam, forKey: .eventAwayTeam)
        try container.encode(eventDate, forKey: .eventDate)
        try container.encode(eventTime, forKey: .eventTime)
        try container.encode(eventFinalResult, forKey: .eventFinalResult)
        try container.encode(homeTeamLogo, forKey: .homeTeamLogo)
        try container.encode(awayTeamLogo, forKey: .awayTeamLogo)
    }
}
