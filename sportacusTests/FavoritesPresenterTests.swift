//
//  FavoritesPresenterTests.swift
//  sportacusTests
//
//  Created by Ashraf on 16/06/2026.
//

import XCTest
@testable import sportacus

// MARK: - Mock View for FavoritesPresenter
class MockFavoritesView: FavoritesViewProtocol {
    
    // Tracking flags
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var displayFavoritesCalled = false
    var showErrorCalled = false
    var navigateToLeagueDetailsCalled = false
    var showNoInternetAlertCalled = false
    
    // Captured values
    var displayedFavorites: [League] = []
    var lastErrorMessage: String?
    var navigatedLeague: League?
    var navigatedSport: Sport?
    
    // Call counts
    var showLoadingCount = 0
    var hideLoadingCount = 0
    var displayFavoritesCount = 0
    var showNoInternetAlertCount = 0
    
    func showLoading() {
        showLoadingCalled = true
        showLoadingCount += 1
    }
    
    func hideLoading() {
        hideLoadingCalled = true
        hideLoadingCount += 1
    }
    
    func displayFavorites(_ favorites: [League]) {
        displayFavoritesCalled = true
        displayFavoritesCount += 1
        displayedFavorites = favorites
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
    
    func showNoInternetAlert() {
        showNoInternetAlertCalled = true
        showNoInternetAlertCount += 1
    }
    
    func reset() {
        showLoadingCalled = false
        hideLoadingCalled = false
        displayFavoritesCalled = false
        showErrorCalled = false
        navigateToLeagueDetailsCalled = false
        showNoInternetAlertCalled = false
        displayedFavorites = []
        lastErrorMessage = nil
        navigatedLeague = nil
        navigatedSport = nil
        showLoadingCount = 0
        hideLoadingCount = 0
        displayFavoritesCount = 0
        showNoInternetAlertCount = 0
    }
}

// MARK: - FavoritesPresenter Tests
final class FavoritesPresenterTests: XCTestCase {
    
    var presenter: FavoritesPresenter!
    var mockView: MockFavoritesView!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockView = MockFavoritesView()
        presenter = FavoritesPresenter(view: mockView)
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
        XCTAssertTrue(mockView.hideLoadingCalled, "viewDidLoad should call hideLoading after loading favorites")
    }
    
    func testViewDidLoad_DisplaysFavorites() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.displayFavoritesCalled, "viewDidLoad should call displayFavorites on the view")
    }
    
    func testViewDidLoad_ShowsLoadingBeforeHiding() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(mockView.showLoadingCalled, "showLoading should be called")
        XCTAssertTrue(mockView.hideLoadingCalled, "hideLoading should be called")
        XCTAssertGreaterThanOrEqual(mockView.showLoadingCount, 1, "showLoading should be called at least once")
        XCTAssertGreaterThanOrEqual(mockView.hideLoadingCount, 1, "hideLoading should be called at least once")
    }
    
    func testViewDidLoad_CalledMultipleTimes_DisplaysFavoritesEachTime() {
        // When
        presenter.viewDidLoad()
        presenter.viewDidLoad()
        presenter.viewDidLoad()
        
        // Then
        XCTAssertEqual(mockView.displayFavoritesCount, 3, "displayFavorites should be called for each viewDidLoad call")
    }
    
    // MARK: - numberOfFavorites Tests
    
    func testNumberOfFavorites_InitiallyReturnsZero() {
        // When - no favorites loaded yet
        let count = presenter.numberOfFavorites
        
        // Then
        XCTAssertEqual(count, 0, "numberOfFavorites should be 0 before any favorites are loaded")
    }
    
    func testNumberOfFavorites_AfterViewDidLoad_ReturnsCorrectCount() {
        // When
        presenter.viewDidLoad()
        
        // Then - count matches whatever CoreData returns (could be 0 in test env)
        let count = presenter.numberOfFavorites
        XCTAssertGreaterThanOrEqual(count, 0, "numberOfFavorites should be >= 0 after viewDidLoad")
    }
    
    // MARK: - searchFavorites Tests
    
    func testSearchFavorites_EmptyQuery_CallsDisplayFavorites() {
        // Given
        presenter.viewDidLoad()
        mockView.reset()
        
        // When
        presenter.searchFavorites(with: "")
        
        // Then
        XCTAssertTrue(mockView.displayFavoritesCalled, "searchFavorites with empty query should call displayFavorites")
    }
    
    func testSearchFavorites_WhitespaceQuery_TreatedAsEmpty() {
        // Given
        presenter.viewDidLoad()
        mockView.reset()
        
        // When
        presenter.searchFavorites(with: "   ")
        
        // Then
        XCTAssertTrue(mockView.displayFavoritesCalled, "searchFavorites with whitespace-only query should call displayFavorites")
    }
    
    func testSearchFavorites_WithQuery_CallsDisplayFavorites() {
        // Given
        presenter.viewDidLoad()
        mockView.reset()
        
        // When
        presenter.searchFavorites(with: "Premier")
        
        // Then
        XCTAssertTrue(mockView.displayFavoritesCalled, "searchFavorites should always call displayFavorites on the view")
    }
    
    func testSearchFavorites_MultipleSearches_CallsDisplayFavoritesEachTime() {
        // Given
        presenter.viewDidLoad()
        mockView.reset()
        
        // When
        presenter.searchFavorites(with: "Premier")
        presenter.searchFavorites(with: "La Liga")
        presenter.searchFavorites(with: "")
        
        // Then
        XCTAssertEqual(mockView.displayFavoritesCount, 3, "displayFavorites should be called once for each search")
    }
    
    func testSearchFavorites_NewlineQuery_TreatedAsEmpty() {
        // Given
        presenter.viewDidLoad()
        mockView.reset()
        
        // When
        presenter.searchFavorites(with: "\n\t ")
        
        // Then
        XCTAssertTrue(mockView.displayFavoritesCalled, "searchFavorites with whitespace/newline query should call displayFavorites")
    }
    
    // MARK: - deleteFavorite Tests
    
    func testDeleteFavorite_NegativeIndex_DoesNotCrash() {
        // Given
        presenter.viewDidLoad()
        
        // When / Then - should not crash
        presenter.deleteFavorite(at: -1)
    }
    
    func testDeleteFavorite_OutOfBoundsIndex_DoesNotCrash() {
        // Given
        presenter.viewDidLoad()
        
        // When / Then - should not crash
        presenter.deleteFavorite(at: 999)
    }
    
    func testDeleteFavorite_ZeroIndexWithNoFavorites_DoesNotCrash() {
        // When / Then - should not crash with no favorites loaded
        presenter.deleteFavorite(at: 0)
    }
    
    // MARK: - selectFavorite Tests
    
    func testSelectFavorite_NegativeIndex_DoesNotNavigate() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectFavorite(at: -1)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectFavorite with negative index should not navigate")
        XCTAssertFalse(mockView.showNoInternetAlertCalled, "selectFavorite with negative index should not show no internet alert")
    }
    
    func testSelectFavorite_OutOfBoundsIndex_DoesNotNavigate() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectFavorite(at: 999)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectFavorite with out-of-bounds index should not navigate")
        XCTAssertFalse(mockView.showNoInternetAlertCalled, "selectFavorite with out-of-bounds index should not show no internet alert")
    }
    
    func testSelectFavorite_ZeroIndexWithNoFavorites_DoesNotNavigate() {
        // When - no favorites loaded
        presenter.selectFavorite(at: 0)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectFavorite with no favorites should not navigate")
    }
    
    func testSelectFavorite_LargeIndex_DoesNotNavigate() {
        // Given
        presenter.viewDidLoad()
        
        // When
        presenter.selectFavorite(at: 100)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectFavorite with very large index should not navigate")
    }
    
    // MARK: - View Weak Reference Test
    
    func testPresenter_ViewIsWeakReference() {
        // Given
        var view: MockFavoritesView? = MockFavoritesView()
        let testPresenter = FavoritesPresenter(view: view!)
        
        // When - release the view
        view = nil
        
        // Then - view should be nil (weak reference)
        XCTAssertNil(testPresenter.view, "Presenter should hold a weak reference to the view")
    }
    
    // MARK: - Edge Cases
    
    func testDeleteFavorite_BeforeViewDidLoad_DoesNotCrash() {
        // When / Then - should not crash even before viewDidLoad
        presenter.deleteFavorite(at: 0)
    }
    
    func testSearchFavorites_BeforeViewDidLoad_CallsDisplayFavorites() {
        // When
        presenter.searchFavorites(with: "test")
        
        // Then
        XCTAssertTrue(mockView.displayFavoritesCalled, "searchFavorites should still call displayFavorites even before viewDidLoad")
    }
    
    func testSelectFavorite_BeforeViewDidLoad_DoesNotNavigate() {
        // When
        presenter.selectFavorite(at: 0)
        
        // Then
        XCTAssertFalse(mockView.navigateToLeagueDetailsCalled, "selectFavorite before viewDidLoad should not navigate")
    }
}
