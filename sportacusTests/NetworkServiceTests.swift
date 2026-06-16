//
//  NetworkServiceTests.swift
//  sportacusTests
//
//  Created by Noureldeen on 16/06/2026.
//

import XCTest
@testable import sportacus

// MARK: - Mock URL Protocol for stubbing network requests
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is not set.")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {}
}

// MARK: - NetworkService Tests
final class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    var originalSession: URLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        networkService = NetworkService.shared
        originalSession = networkService.session
        
        // Configure ephemeral session with MockURLProtocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        networkService.session = URLSession(configuration: config)
    }
    
    override func tearDownWithError() throws {
        networkService.session = originalSession
        networkService = nil
        MockURLProtocol.requestHandler = nil
        try super.tearDownWithError()
    }
    
    // MARK: - fetchLeagues Tests
    
    func testFetchLeagues_Success_ReturnsLeagues() {
        // Given
        let expectation = self.expectation(description: "Fetch leagues completion")
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "league_key": 4,
                    "league_name": "UEFA Champions League",
                    "league_logo": "cl.png",
                    "country_name": "Europe"
                }
            ]
        }
        """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        networkService.fetchLeagues(for: .football) { result in
            // Then
            switch result {
            case .success(let leagues):
                XCTAssertEqual(leagues.count, 1)
                XCTAssertEqual(leagues.first?.leagueKey, 4)
                XCTAssertEqual(leagues.first?.leagueName, "UEFA Champions League")
            case .failure(let error):
                XCTFail("Expected success, but got failure with error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchLeagues_FailureResponse_ReturnsError() {
        // Given
        let expectation = self.expectation(description: "Fetch leagues error")
        let jsonString = """
        {
            "success": 0,
            "result": "Database down"
        }
        """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        networkService.fetchLeagues(for: .football) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // MARK: - fetchEvents Tests
    
    func testFetchEvents_Success_ReturnsEvents() {
        // Given
        let expectation = self.expectation(description: "Fetch events completion")
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "event_key": 101,
                    "event_home_team": "Liverpool",
                    "event_away_team": "Chelsea",
                    "event_date": "2026-06-16",
                    "event_time": "21:00",
                    "event_final_result": "2 - 2"
                }
            ]
        }
        """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        networkService.fetchEvents(for: .football, leagueId: 152, from: "2026-06-01", to: "2026-06-30") { result in
            // Then
            switch result {
            case .success(let events):
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events.first?.eventKey, 101)
                XCTAssertEqual(events.first?.eventHomeTeam, "Liverpool")
                XCTAssertEqual(events.first?.eventAwayTeam, "Chelsea")
            case .failure(let error):
                XCTFail("Expected success, but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchEvents_NoEventsFound_ReturnsEmptyArray() {
        // Given
        let expectation = self.expectation(description: "Fetch empty events")
        // AllSportsAPI returns success = 0 and result containing error message when there are no fixtures
        let jsonString = """
        {
            "success": 0,
            "result": "No events found"
        }
        """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        networkService.fetchEvents(for: .football, leagueId: 152, from: "2026-06-01", to: "2026-06-30") { result in
            // Then
            switch result {
            case .success(let events):
                XCTAssertEqual(events.count, 0, "Should handle success: 0 as empty events array rather than crashing or returning failure")
            case .failure(let error):
                XCTFail("Expected success with empty array, but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    // MARK: - fetchTeams Tests
    
    func testFetchTeams_Success_ReturnsTeams() {
        // Given
        let expectation = self.expectation(description: "Fetch teams completion")
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "team_key": 99,
                    "team_name": "Man City",
                    "team_logo": "mancity.png"
                }
            ]
        }
        """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        networkService.fetchTeams(for: .football, leagueId: 152) { result in
            // Then
            switch result {
            case .success(let teams):
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamKey, 99)
                XCTAssertEqual(teams.first?.teamName, "Man City")
            case .failure(let error):
                XCTFail("Expected success, but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchTeams_TennisPlayers_ReturnsPlayersAsTeams() {
        // Given
        let expectation = self.expectation(description: "Fetch players completion")
        let jsonString = """
        {
            "success": 1,
            "result": [
                {
                    "player_key": 77,
                    "player_name": "Federer",
                    "player_logo": "fed.png"
                }
            ]
        }
        """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            // Verify that Tennis correctly targets Players instead of Teams met
            XCTAssertTrue(request.url!.absoluteString.contains("met=Players"))
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        networkService.fetchTeams(for: .tennis, leagueId: 152) { result in
            // Then
            switch result {
            case .success(let teams):
                XCTAssertEqual(teams.count, 1)
                XCTAssertEqual(teams.first?.teamKey, 77)
                XCTAssertEqual(teams.first?.teamName, "Federer")
                XCTAssertEqual(teams.first?.teamLogo, "fed.png")
            case .failure(let error):
                XCTFail("Expected success, but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testFetchTeams_ErrorStringResponse_ReturnsEmptyArray() {
        // Given
        let expectation = self.expectation(description: "Fetch teams empty / error string")
        // Mismatched result type returning error message instead of array (our main bug source)
        let jsonString = """
        {
            "success": 0,
            "result": "No teams found for league"
        }
        """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // When
        networkService.fetchTeams(for: .basketball, leagueId: 152) { result in
            // Then
            switch result {
            case .success(let teams):
                XCTAssertEqual(teams.count, 0, "Should handle success: 0 as empty array")
            case .failure(let error):
                XCTFail("Expected success (empty array) but failed with: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
