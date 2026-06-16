//
//  ModelTests.swift
//  sportacusTests
//
//  Created by Noureldeen on 16/06/2026.
//

import XCTest
@testable import sportacus

final class ModelTests: XCTestCase {

    // MARK: - League Model Decoding Tests

    func testLeagueDecoding_WithInt64Key_Succeeds() throws {
        let json = """
        {
            "league_key": 142,
            "league_name": "Premier League",
            "league_logo": "logo.png",
            "country_name": "England"
        }
        """.data(using: .utf8)!

        let league = try JSONDecoder().decode(League.self, from: json)
        XCTAssertEqual(league.leagueKey, 142)
        XCTAssertEqual(league.leagueName, "Premier League")
        XCTAssertEqual(league.leagueLogo, "logo.png")
        XCTAssertEqual(league.countryName, "England")
    }

    func testLeagueDecoding_WithIntKey_Succeeds() throws {
        let json = """
        {
            "league_key": 55,
            "league_name": "La Liga",
            "league_logo": null,
            "country_name": "Spain"
        }
        """.data(using: .utf8)!

        let league = try JSONDecoder().decode(League.self, from: json)
        XCTAssertEqual(league.leagueKey, 55)
        XCTAssertEqual(league.leagueName, "La Liga")
        XCTAssertNil(league.leagueLogo)
        XCTAssertEqual(league.countryName, "Spain")
    }

    func testLeagueDecoding_WithStringKey_Succeeds() throws {
        let json = """
        {
            "league_key": "999",
            "league_name": "Serie A",
            "country_name": "Italy"
        }
        """.data(using: .utf8)!

        let league = try JSONDecoder().decode(League.self, from: json)
        XCTAssertEqual(league.leagueKey, 999)
        XCTAssertEqual(league.leagueName, "Serie A")
        XCTAssertNil(league.leagueLogo)
        XCTAssertEqual(league.countryName, "Italy")
    }

    func testLeagueDecoding_WithMissingCountryAndName_DefaultsCorrectly() throws {
        let json = """
        {
            "league_key": "invalid_key_type"
        }
        """.data(using: .utf8)!

        let league = try JSONDecoder().decode(League.self, from: json)
        XCTAssertEqual(league.leagueKey, 0)
        XCTAssertEqual(league.leagueName, "Unknown League")
        XCTAssertEqual(league.countryName, "International")
    }

    // MARK: - APIEvent Decoding Tests

    func testAPIEventDecoding_FootballFormat_Succeeds() throws {
        let json = """
        {
            "event_key": 20452,
            "event_home_team": "Liverpool",
            "event_away_team": "Chelsea",
            "event_date": "2026-06-20",
            "event_time": "18:00",
            "event_final_result": "3 - 1",
            "home_team_logo": "liverpool.png",
            "away_team_logo": "chelsea.png"
        }
        """.data(using: .utf8)!

        let event = try JSONDecoder().decode(APIEvent.self, from: json)
        XCTAssertEqual(event.eventKey, 20452)
        XCTAssertEqual(event.eventHomeTeam, "Liverpool")
        XCTAssertEqual(event.eventAwayTeam, "Chelsea")
        XCTAssertEqual(event.eventDate, "2026-06-20")
        XCTAssertEqual(event.eventTime, "18:00")
        XCTAssertEqual(event.eventFinalResult, "3 - 1")
        XCTAssertEqual(event.homeTeamLogo, "liverpool.png")
        XCTAssertEqual(event.awayTeamLogo, "chelsea.png")
    }

    func testAPIEventDecoding_TennisFormat_Succeeds() throws {
        let json = """
        {
            "event_key": "305",
            "event_first_player": "Nadal",
            "event_second_player": "Federer",
            "event_date": "2026-07-01",
            "event_time": "15:30",
            "event_first_player_logo": "nadal.png",
            "event_second_player_logo": "federer.png"
        }
        """.data(using: .utf8)!

        let event = try JSONDecoder().decode(APIEvent.self, from: json)
        XCTAssertEqual(event.eventKey, 305)
        XCTAssertEqual(event.eventHomeTeam, "Nadal")
        XCTAssertEqual(event.eventAwayTeam, "Federer")
        XCTAssertEqual(event.homeTeamLogo, "nadal.png")
        XCTAssertEqual(event.awayTeamLogo, "federer.png")
    }
}
