//
//  SportsPresenterTests.swift
//  sportacusTests
//
//  Created by Ashraf on 16/06/2026.
//

import XCTest
@testable import sportacus

// MARK: - Mock View for SportsPresenter
class MockSportsView: SportsViewProtocol {
    
    // Tracking flags
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displaySportsCalled = false
    var showErrorCalled = false
    var navigateToLeaguesCalled = false
    
    // Captured values
    var displayedSports: [Sport] = []
    var lastErrorMessage: String?
    var navigatedSport: Sport?
    
    // Call counts
    var showLoadingCount = 0
    var hideLoadingCount = 0
    var displaySportsCount = 0
    var navigateToLeaguesCount = 0
    
    func showLoading() {
        showLoadingCalled = true
        showLoadingCount += 1
    }
    
    func hideLoading() {
        hideLoadingCalled = true
        hideLoadingCount += 1
    }
    
    func displaySports(_ sports: [Sport]) {
        displaySportsCalled = true
        displaySportsCount += 1
        displayedSports = sports
    }
    
    func showError(_ message: String) {
        showErrorCalled = true
        lastErrorMessage = message
    }
    
    func navigateToLeagues(for sport: Sport) {
        navigateToLeaguesCalled = true
        navigateToLeaguesCount += 1
        navigatedSport = sport
    }
    
    func reset() {
        showLoadingCalled = false
        hideLoadingCalled = false
        displaySportsCalled = false
        showErrorCalled = false
        navigateToLeaguesCalled = false
        displayedSports = []
        lastErrorMessage = nil
        navigatedSport = nil
        showLoadingCount = 0
        hideLoadingCount = 0
        displaySportsCount = 0
        navigateToLeaguesCount = 0
    }
}

// MARK: - SportsPresenter Tests
final class SportsPresenterTests: XCTestCase {
    
    var presenter: SportsPresenter!
    var mockView: MockSportsView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = MockSportsView()
        presenter = SportsPresenter(view: mockView)
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
    
    // MARK: - viewDidLoad Tests
    
    func testViewDidLoad_ShowsLoading() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.showLoadingCalled, "viewDidLoad should call showLoading on the view")
    }
    
    func testViewDidLoad_HidesLoadingAfterLoading() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.hideLoadingCalled, "viewDidLoad should call hideLoading after loading sports")
    }
    
    func testViewDidLoad_DisplaysSports() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.displaySportsCalled, "viewDidLoad should call displaySports on the view")
    }
    
    func testViewDidLoad_DisplaysAllSportCategories() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(mockView.displayedSports.count, Sport.allCases.count, "Should display all sport categories")
    }
    
    func testViewDidLoad_DisplaysSportsInCorrectOrder() {
        // When
        presenter.viewDidLoad()
        
        // Then
        let expectedSports = Sport.allCases
        XCTAssertEqual(mockView.displayedSports, expectedSports, "Sports should be displayed in allCases order")
    }
    
    func testViewDidLoad_ContainsFootball() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.displayedSports.contains(.football), "Displayed sports should contain football")
    }
    
    func testViewDidLoad_ContainsBasketball() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.displayedSports.contains(.basketball), "Displayed sports should contain basketball")
    }
    
    func testViewDidLoad_ContainsCricket() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.displayedSports.contains(.cricket), "Displayed sports should contain cricket")
    }
    
    func testViewDidLoad_ContainsTennis() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.displayedSports.contains(.tennis), "Displayed sports should contain tennis")
    }
    
    func testViewDidLoad_ShowsLoadingBeforeHiding() {
        // When
        presenter.viewDidLoad()
        
        // Then - both should be called
        XCTAssertTrue(mockView.showLoadingCalled, "showLoading should be called")
        XCTAssertTrue(mockView.hideLoadingCalled, "hideLoading should be called")
        XCTAssertGreaterThanOrEqual(mockView.showLoadingCount, 1, "showLoading should be called at least once")
        XCTAssertGreaterThanOrEqual(mockView.hideLoadingCount, 1, "hideLoading should be called at least once")
    }
    
    func testViewDidLoad_CalledMultipleTimes_DisplaysSportsEachTime() {
        // When
        presenter.viewDidLoad()
        presenter.viewDidLoad()
        presenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(mockView.displaySportsCount, 3, "displaySports should be called for each viewDidLoad call")
    }
    
    // MARK: - selectSport Tests
    
    func testSelectSport_Football_NavigatesToFootball() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectSport(at: 0)
        
        // Then
        XCTAssertTrue(mockView.navigateToLeaguesCalled, "selectSport should call navigateToLeagues")
        XCTAssertEqual(mockView.navigatedSport, .football, "Should navigate to football for index 0")
    }
    
    func testSelectSport_Basketball_NavigatesToBasketball() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectSport(at: 1)
        
        // Then
        XCTAssertTrue(mockView.navigateToLeaguesCalled, "selectSport should call navigateToLeagues")
        XCTAssertEqual(mockView.navigatedSport, .basketball, "Should navigate to basketball for index 1")
    }
    
    func testSelectSport_Cricket_NavigatesToCricket() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectSport(at: 2)
        
        // Then
        XCTAssertTrue(mockView.navigateToLeaguesCalled, "selectSport should call navigateToLeagues")
        XCTAssertEqual(mockView.navigatedSport, .cricket, "Should navigate to cricket for index 2")
    }
    
    func testSelectSport_Tennis_NavigatesToTennis() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectSport(at: 3)
        
        // Then
        XCTAssertTrue(mockView.navigateToLeaguesCalled, "selectSport should call navigateToLeagues")
        XCTAssertEqual(mockView.navigatedSport, .tennis, "Should navigate to tennis for index 3")
    }
    
    func testSelectSport_NegativeIndex_DoesNotNavigate() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectSport(at: -1)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeaguesCalled, "selectSport with negative index should not navigate")
    }
    
    func testSelectSport_OutOfBoundsIndex_DoesNotNavigate() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectSport(at: 4)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeaguesCalled, "selectSport with out-of-bounds index should not navigate")
    }
    
    func testSelectSport_LargeIndex_DoesNotNavigate() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectSport(at: 999)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeaguesCalled, "selectSport with very large index should not navigate")
    }
    
    func testSelectSport_BeforeViewDidLoad_DoesNotNavigate() {
        // When - selectSport called before viewDidLoad (no sports loaded)
        presenter.selectSport(at: 0)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeaguesCalled, "selectSport before viewDidLoad should not navigate (no sports loaded)")
    }
    
    func testSelectSport_MultipleSelections_NavigatesEachTime() {
        // Given
        presenter.viewDidLoad()
        mockView.reset()
        
        // When
        presenter.selectSport(at: 0)
        presenter.selectSport(at: 1)
        presenter.selectSport(at: 2)
        presenter.selectSport(at: 3)
        
        // Then
        XCTAssertEqual(mockView.navigateToLeaguesCount, 4, "navigateToLeagues should be called for each valid selection")
    }
    
    func testSelectSport_InvalidThenValid_OnlyNavigatesOnce() {
        // Given
        presenter.viewDidLoad()
        mockView.reset()
        
        // When
        presenter.selectSport(at: -1)
        presenter.selectSport(at: 999)
        presenter.selectSport(at: 0) // only this one is valid
        
        // Then
        XCTAssertEqual(mockView.navigateToLeaguesCount, 1, "Only valid selections should trigger navigation")
        XCTAssertEqual(mockView.navigatedSport, .football)
    }
    
    // MARK: - View Weak Reference Test
    
    func testPresenter_ViewIsWeakReference() {
        // Given
        var view: MockSportsView? = MockSportsView()
        let testPresenter = SportsPresenter(view: view!)
        
        // When - release the view
        view = nil
        
        // Then - view should be nil (weak reference)
        XCTAssertNil(testPresenter.view, "Presenter should hold a weak reference to the view")
    }
}
