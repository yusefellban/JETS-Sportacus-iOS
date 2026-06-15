//
//  LeaguesPresenterTests.swift
//  sportacusTests
//
//  Created by Unit Tests on 15/06/2026.
//

import XCTest
@testable import sportacus

// MARK: - Mock View for LeaguesPresenter
class MockLeaguesView: LeaguesViewProtocol {
    
    // Tracking flags
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displayLeaguesCalled = false
    var showErrorCalled = false
    var navigateToLeagueDetailsCalled = false
    
    // Captured values
    var displayedLeagues: [League] = []
    var lastErrorMessage: String?
    var navigatedLeague: League?
    var navigatedSport: Sport?
    
    // Call counts
    var showLoadingCount = 0
    var hideLoadingCount = 0
    var displayLeaguesCount = 0
    
    func showLoading() {
        showLoadingCalled = true
        showLoadingCount += 1
    }
    
    func hideLoading() {
        hideLoadingCalled = true
        hideLoadingCount += 1
    }
    
    func displayLeagues(_ leagues: [League]) {
        displayLeaguesCalled = true
        displayLeaguesCount += 1
        displayedLeagues = leagues
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        lastErrorMessage = message
    }
    
    func navigateToLeagueDetails(for league: League, sport: Sport) {
        navigateToLeagueDetailsCalled = true
        navigatedLeague = league
        navigatedSport = sport
    }
    
    func reset() {
        showLoadingCalled = false
        hideLoadingCalled = false
        displayLeaguesCalled = false
        showErrorCalled = false
        navigateToLeagueDetailsCalled = false
        displayedLeagues = []
        lastErrorMessage = nil
        navigatedLeague = nil
        navigatedSport = nil
        showLoadingCount = 0
        hideLoadingCount = 0
        displayLeaguesCount = 0
    }
}

// MARK: - LeaguesPresenter Tests
final class LeaguesPresenterTests: XCTestCase {
    
    var presenter: LeaguesPresenter!
    var mockView: MockLeaguesView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = MockLeaguesView()
        presenter = LeaguesPresenter(view: mockView, sport: .football)
    }
    
    override func tearDownWithError() throws {
        presenter = nil
        mockView = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Initialization Tests
    
    func testPresenterInit_SetsViewCorrectly() {
        // Then
        XCTAssertNotNil(presenter.view, "Presenter view should not be nil after initialization")
    }
    
    func testPresenterInit_WithDifferentSports() {
        // Test initialization with each sport type
        for sport in Sport.allCases {
            let view = MockLeaguesView()
            let sportPresenter = LeaguesPresenter(view: view, sport: sport)
            XCTAssertNotNil(sportPresenter.view, "Presenter should initialize correctly for \(sport.displayName)")
        }
    }
    
    // MARK: - viewDidLoad Tests
    
    func testViewDidLoad_ShowsLoading() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.showLoadingCalled, "viewDidLoad should call showLoading on the view")
    }
    
    // MARK: - numberOfLeagues Tests
    
    func testNumberOfLeagues_InitiallyReturnsZero() {
        // When - no leagues loaded yet
        let count = presenter.numberOfLeagues
        
        // Then
        XCTAssertEqual(count, 0, "numberOfLeagues should be 0 before any leagues are loaded")
    }
    
    // MARK: - searchLeagues Tests
    
    func testSearchLeagues_EmptyQuery_CallsDisplayLeagues() {
        // When
        presenter.searchLeagues(with: "")
        
        // Then
        XCTAssertTrue(mockView.displayLeaguesCalled, "searchLeagues with empty query should call displayLeagues")
    }
    
    func testSearchLeagues_WhitespaceQuery_TreatedAsEmpty() {
        // When
        presenter.searchLeagues(with: "   ")
        
        // Then
        XCTAssertTrue(mockView.displayLeaguesCalled, "searchLeagues with whitespace-only query should call displayLeagues")
        XCTAssertEqual(mockView.displayedLeagues.count, 0, "No leagues should be displayed when nothing is loaded")
    }
    
    func testSearchLeagues_WithQuery_CallsDisplayLeagues() {
        // When
        presenter.searchLeagues(with: "Premier")
        
        // Then
        XCTAssertTrue(mockView.displayLeaguesCalled, "searchLeagues should always call displayLeagues on the view")
    }
    
    func testSearchLeagues_MultipleSearches_CallsDisplayLeaguesEachTime() {
        // When
        presenter.searchLeagues(with: "Premier")
        presenter.searchLeagues(with: "La Liga")
        presenter.searchLeagues(with: "")
        
        // Then
        XCTAssertEqual(mockView.displayLeaguesCount, 3, "displayLeagues should be called once for each search")
    }
    
    // MARK: - selectLeague Tests
    
    func testSelectLeague_NegativeIndex_DoesNotNavigate() {
        // When
        presenter.selectLeague(at: -1)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectLeague with negative index should not navigate")
    }
    
    func testSelectLeague_OutOfBoundsIndex_DoesNotNavigate() {
        // When - no leagues loaded, index 0 is out of bounds
        presenter.selectLeague(at: 0)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectLeague with out-of-bounds index should not navigate")
    }
    
    func testSelectLeague_LargeIndex_DoesNotNavigate() {
        // When
        presenter.selectLeague(at: 999)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectLeague with very large index should not navigate")
    }
    
    // MARK: - toggleFavorite Tests
    
    func testToggleFavorite_NegativeIndex_DoesNotCrash() {
        // When / Then - should not crash
        presenter.toggleFavorite(at: -1)
        
        // The view should not be called to display leagues for invalid index
        // (the guard statement returns early)
    }
    
    func testToggleFavorite_OutOfBoundsIndex_DoesNotCrash() {
        // When / Then - should not crash
        presenter.toggleFavorite(at: 100)
    }
    
    // MARK: - View Weak Reference Test
    
    func testPresenter_ViewIsWeakReference() {
        // Given
        var view: MockLeaguesView? = MockLeaguesView()
        let testPresenter = LeaguesPresenter(view: view!, sport: .football)
        
        // When - release the view
        view = nil
        
        // Then - view should be nil (weak reference)
        XCTAssertNil(testPresenter.view, "Presenter should hold a weak reference to the view")
    }
    
    // MARK: - Sport Variants Tests
    
    func testPresenter_FootballSport() {
        let view = MockLeaguesView()
        let p = LeaguesPresenter(view: view, sport: .football)
        p.viewDidLoad()
        XCTAssertTrue(view.showLoadingCalled, "Football presenter should show loading on viewDidLoad")
    }
    
    func testPresenter_BasketballSport() {
        let view = MockLeaguesView()
        let p = LeaguesPresenter(view: view, sport: .basketball)
        p.viewDidLoad()
        XCTAssertTrue(view.showLoadingCalled, "Basketball presenter should show loading on viewDidLoad")
    }
    
    func testPresenter_CricketSport() {
        let view = MockLeaguesView()
        let p = LeaguesPresenter(view: view, sport: .cricket)
        p.viewDidLoad()
        XCTAssertTrue(view.showLoadingCalled, "Cricket presenter should show loading on viewDidLoad")
    }
    
    func testPresenter_TennisSport() {
        let view = MockLeaguesView()
        let p = LeaguesPresenter(view: view, sport: .tennis)
        p.viewDidLoad()
        XCTAssertTrue(view.showLoadingCalled, "Tennis presenter should show loading on viewDidLoad")
    }
}
