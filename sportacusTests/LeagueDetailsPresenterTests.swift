//
//  LeagueDetailsPresenterTests.swift
//  sportacusTests
//
//  Created by Unit Tests on 15/06/2026.
//

import XCTest
@testable import sportacus

// MARK: - Mock View for LeagueDetailsPresenter
class MockLeagueDetailsView: LeagueDetailsViewProtocol {
    
    // Tracking flags
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displayLeagueNameCalled = false
    var displayUpcomingEventsCalled = false
    var displayLatestEventsCalled = false
    var displayTeamsCalled = false
    var showFavoriteStateCalled = false
    
    // Captured values
    var displayedLeagueName: String?
    var displayedUpcomingEvents: [UpcomingEvent] = []
    var displayedLatestEvents: [LatestEvent] = []
    var displayedTeams: [Team] = []
    var lastFavoriteState: Bool?
    
    // Call counts
    var showLoadingCount = 0
    var hideLoadingCount = 0
    var showFavoriteStateCount = 0
    
    func showLoading() {
        showLoadingCalled = true
        showLoadingCount += 1
    }
    
    func hideLoading() {
        hideLoadingCalled = true
        hideLoadingCount += 1
    }
    
    func displayLeagueName(_ name: String) {
        displayLeagueNameCalled = true
        displayedLeagueName = name
    }
    
    func displayUpcomingEvents(_ events: [UpcomingEvent]) {
        displayUpcomingEventsCalled = true
        displayedUpcomingEvents = events
    }
    
    func displayLatestEvents(_ events: [LatestEvent]) {
        displayLatestEventsCalled = true
        displayedLatestEvents = events
    }
    
    func displayTeams(_ teams: [Team]) {
        displayTeamsCalled = true
        displayedTeams = teams
    }
    
    func showFavoriteState(isFavorite: Bool) {
        showFavoriteStateCalled = true
        showFavoriteStateCount += 1
        lastFavoriteState = isFavorite
    }
    
    func reset() {
        showLoadingCalled = false
        hideLoadingCalled = false
        displayLeagueNameCalled = false
        displayUpcomingEventsCalled = false
        displayLatestEventsCalled = false
        displayTeamsCalled = false
        showFavoriteStateCalled = false
        displayedLeagueName = nil
        displayedUpcomingEvents = []
        displayedLatestEvents = []
        displayedTeams = []
        lastFavoriteState = nil
        showLoadingCount = 0
        hideLoadingCount = 0
        showFavoriteStateCount = 0
    }
}

// MARK: - Test Helpers
extension LeagueDetailsPresenterTests {
    
    func makeSampleLeague(
        key: Int64 = 1,
        name: String = "Premier League",
        logo: String? = "logo.png",
        country: String = "England"
    ) -> League {
        return League(leagueKey: key, leagueName: name, leagueLogo: logo, countryName: country)
    }
}

// MARK: - LeagueDetailsPresenter Tests
final class LeagueDetailsPresenterTests: XCTestCase {
    
    var presenter: LeagueDetailsPresenter!
    var mockView: MockLeagueDetailsView!
    var testLeague: League!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = MockLeagueDetailsView()
        testLeague = League(
            leagueKey: 152,
            leagueName: "Premier League",
            leagueLogo: "https://example.com/logo.png",
            countryName: "England"
        )
        presenter = LeagueDetailsPresenter(view: mockView, league: testLeague, sport: .football)
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        mockView = nil
        testLeague = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initialization Tests
    
    func testPresenterInit_SetsViewCorrectly() {
        // Then
        XCTAssertNotNil(presenter.view, "Presenter view should not be nil after initialization")
    }
    
    func testPresenterInit_StoresLeague() {
        // Then
        XCTAssertEqual(presenter.league.leagueKey, 152, "Presenter should store the correct league key")
        XCTAssertEqual(presenter.league.leagueName, "Premier League", "Presenter should store the correct league name")
    }
    
    func testPresenterInit_IsFavoriteDefaultsFalse() {
        // Then
        XCTAssertFalse(presenter.isFavorite, "isFavorite should default to false before viewDidLoad")
    }
    
    func testPresenterInit_WithDifferentSports() {
        // Test with each sport
        let sports: [Sport] = [.football, .basketball, .cricket, .tennis]
        for sport in sports {
            let view = MockLeagueDetailsView()
            let p = LeagueDetailsPresenter(view: view, league: testLeague, sport: sport)
            XCTAssertNotNil(p.view, "Presenter should initialize correctly for sport: \(sport.displayName)")
            XCTAssertEqual(p.league.leagueKey, testLeague.leagueKey)
        }
    }
    
    func testPresenterInit_WithDifferentLeagues() {
        // Given
        let league1 = makeSampleLeague(key: 100, name: "La Liga", country: "Spain")
        let league2 = makeSampleLeague(key: 200, name: "Serie A", country: "Italy")
        let league3 = makeSampleLeague(key: 300, name: "Bundesliga", country: "Germany")
        
        // When
        let p1 = LeagueDetailsPresenter(view: mockView, league: league1, sport: .football)
        let p2 = LeagueDetailsPresenter(view: mockView, league: league2, sport: .football)
        let p3 = LeagueDetailsPresenter(view: mockView, league: league3, sport: .football)
        
        // Then
        XCTAssertEqual(p1.league.leagueName, "La Liga")
        XCTAssertEqual(p2.league.leagueName, "Serie A")
        XCTAssertEqual(p3.league.leagueName, "Bundesliga")
    }
    
    // MARK: - viewDidLoad Tests
    
    func testViewDidLoad_ShowsLoading() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.showLoadingCalled, "viewDidLoad should call showLoading on the view")
    }
    
    func testViewDidLoad_DisplaysLeagueName() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.displayLeagueNameCalled, "viewDidLoad should call displayLeagueName on the view")
        XCTAssertEqual(mockView.displayedLeagueName, "Premier League", "Should display the correct league name")
    }
    
    func testViewDidLoad_ShowsFavoriteState() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.showFavoriteStateCalled, "viewDidLoad should call showFavoriteState on the view")
        XCTAssertNotNil(mockView.lastFavoriteState, "lastFavoriteState should not be nil after viewDidLoad")
    }
    
    func testViewDidLoad_DisplaysCorrectLeagueName_ForDifferentLeagues() {
        // Given
        let league = makeSampleLeague(name: "Bundesliga")
        let view = MockLeagueDetailsView()
        let p = LeagueDetailsPresenter(view: view, league: league, sport: .football)
        
        // When
        p.viewDidLoad()
        
        // Then
        XCTAssertEqual(view.displayedLeagueName, "Bundesliga", "Should display the correct league name for Bundesliga")
    }
    
    func testViewDidLoad_ShowsLoading_BeforeAnythingElse() {
        // When
        presenter.viewDidLoad()
        
        // Then - showLoading should have been called
        XCTAssertTrue(mockView.showLoadingCalled)
        XCTAssertGreaterThanOrEqual(mockView.showLoadingCount, 1, "showLoading should be called at least once")
    }
    
    // MARK: - selectTeam Tests
    
    func testSelectTeam_NegativeIndex_DoesNotCrash() {
        // When / Then - should not crash
        presenter.selectTeam(at: -1)
    }
    
    func testSelectTeam_OutOfBoundsIndex_DoesNotCrash() {
        // When - no teams loaded, index 0 is out of bounds
        presenter.selectTeam(at: 0)
    }
    
    func testSelectTeam_VeryLargeIndex_DoesNotCrash() {
        // When / Then - should not crash
        presenter.selectTeam(at: 999)
    }
    
    // MARK: - toggleFavorite Tests
    
    func testToggleFavorite_TogglesIsFavoriteProperty() {
        // Given
        let initialState = presenter.isFavorite
        
        // When
        presenter.toggleFavorite()
        
        // Then
        XCTAssertNotEqual(presenter.isFavorite, initialState, "toggleFavorite should toggle the isFavorite state")
    }
    
    func testToggleFavorite_DoubleToggle_ReturnsToOriginalState() {
        // Given
        let initialState = presenter.isFavorite
        
        // When
        presenter.toggleFavorite()
        presenter.toggleFavorite()
        
        // Then
        XCTAssertEqual(presenter.isFavorite, initialState, "Toggling twice should return to the original state")
    }
    
    func testToggleFavorite_CallsShowFavoriteStateOnView() {
        // Given
        mockView.reset()
        
        // When
        presenter.toggleFavorite()
        
        // Then
        XCTAssertTrue(mockView.showFavoriteStateCalled, "toggleFavorite should call showFavoriteState on the view")
    }
    
    func testToggleFavorite_PassesCorrectState_WhenTogglingOn() {
        // Given - starts as false
        XCTAssertFalse(presenter.isFavorite)
        mockView.reset()
        
        // When
        presenter.toggleFavorite()
        
        // Then
        XCTAssertTrue(presenter.isFavorite, "isFavorite should be true after toggling from false")
        XCTAssertEqual(mockView.lastFavoriteState, true, "View should be notified with isFavorite = true")
    }
    
    func testToggleFavorite_PassesCorrectState_WhenTogglingOff() {
        // Given - toggle on first
        presenter.toggleFavorite()
        XCTAssertTrue(presenter.isFavorite)
        mockView.reset()
        
        // When
        presenter.toggleFavorite()
        
        // Then
        XCTAssertFalse(presenter.isFavorite, "isFavorite should be false after toggling from true")
        XCTAssertEqual(mockView.lastFavoriteState, false, "View should be notified with isFavorite = false")
    }
    
    func testToggleFavorite_MultipleToggles_AlternatesCorrectly() {
        // Given
        XCTAssertFalse(presenter.isFavorite)
        
        // When / Then - toggle multiple times and verify each state
        presenter.toggleFavorite()
        XCTAssertTrue(presenter.isFavorite, "1st toggle: should be true")
        
        presenter.toggleFavorite()
        XCTAssertFalse(presenter.isFavorite, "2nd toggle: should be false")
        
        presenter.toggleFavorite()
        XCTAssertTrue(presenter.isFavorite, "3rd toggle: should be true")
        
        presenter.toggleFavorite()
        XCTAssertFalse(presenter.isFavorite, "4th toggle: should be false")
    }
    
    func testToggleFavorite_CallsShowFavoriteState_EachTime() {
        // Given
        mockView.reset()
        
        // When
        presenter.toggleFavorite()
        presenter.toggleFavorite()
        presenter.toggleFavorite()
        
        // Then
        XCTAssertEqual(mockView.showFavoriteStateCount, 3, "showFavoriteState should be called for each toggle")
    }
    
    // MARK: - View Weak Reference Test
    
    func testPresenter_ViewIsWeakReference() {
        // Given
        var view: MockLeagueDetailsView? = MockLeagueDetailsView()
        let league = makeSampleLeague()
        let testPresenter = LeagueDetailsPresenter(view: view!, league: league, sport: .football)
        
        // When - release the view
        view = nil
        
        // Then - view should be nil (weak reference)
        XCTAssertNil(testPresenter.view, "Presenter should hold a weak reference to the view")
    }
    
    // MARK: - League Property Tests
    
    func testLeague_HasCorrectKey() {
        XCTAssertEqual(presenter.league.leagueKey, 152)
    }
    
    func testLeague_HasCorrectName() {
        XCTAssertEqual(presenter.league.leagueName, "Premier League")
    }
    
    func testLeague_HasCorrectCountry() {
        XCTAssertEqual(presenter.league.countryName, "England")
    }
    
    func testLeague_HasCorrectLogo() {
        XCTAssertEqual(presenter.league.leagueLogo, "https://example.com/logo.png")
    }
    
    func testLeague_WithNilLogo() {
        // Given
        let league = makeSampleLeague(logo: nil)
        let view = MockLeagueDetailsView()
        let p = LeagueDetailsPresenter(view: view, league: league, sport: .football)
        
        // Then
        XCTAssertNil(p.league.leagueLogo, "League logo should be nil when initialized with nil")
    }
}
