//
//  MovieFinderViewModelTests.swift
//  MovieFinderTests
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import XCTest
@testable import MovieFinder

@MainActor
final class MovieFinderViewModelTests: XCTestCase {
    
    // MARK: - Test Properties
    var viewModel: MovieSearchViewModel!
    var mockService: MockMovieService!
    
    override func setUp() {
        super.setUp()
        mockService = MockMovieService()
        viewModel = MovieSearchViewModel(movieService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - MovieSearchViewModel Tests
    
    func testViewModelInitialization() {
        // Test initial state
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertNil(viewModel.selectedMovie)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isLoadingMovieDetails)
        XCTAssertFalse(viewModel.isLoadingMore)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showingError)
        XCTAssertEqual(viewModel.viewLayout, .list)
        XCTAssertFalse(viewModel.isSearching)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertEqual(viewModel.totalResults, 0)
    }
    
    func testSearchMoviesSuccess() async {
        // Given
        let expectedResults = [
            SearchResult(title: "Batman Begins", year: "2005", imdbID: "tt0372784", type: "movie", poster: "batman.jpg")
        ]
        
        mockService.mockSearchResults = expectedResults
        mockService.mockTotalResults = 20
        mockService.mockHasMorePages = true
        viewModel.searchText = "Batman"
        
        // When
        await viewModel.searchMovies()
        
        // Then
        XCTAssertEqual(viewModel.searchResults.count, 1)
        XCTAssertEqual(viewModel.searchResults[0].title, "Batman Begins")
        XCTAssertEqual(viewModel.totalResults, 20)
        XCTAssertTrue(viewModel.canLoadMore)
        XCTAssertTrue(viewModel.isSearching)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showingError)
    }
    
    func testSearchMoviesNoResults() async {
        // Given
        mockService.mockSearchResults = []
        mockService.mockTotalResults = 0
        mockService.mockHasMorePages = false
        viewModel.searchText = "NonexistentMovie"
        
        // When
        await viewModel.searchMovies()
        
        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertEqual(viewModel.errorMessage, "Movie not found")
        XCTAssertTrue(viewModel.showingError)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertEqual(viewModel.totalResults, 0)
    }
    
    func testSearchMoviesError() async {
        // Given
        mockService.shouldReturnError = true
        viewModel.searchText = "Batman"
        
        // When
        await viewModel.searchMovies()
        
        // Then
        XCTAssertTrue(viewModel.searchResults.isEmpty)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showingError)
        XCTAssertFalse(viewModel.canLoadMore)
        XCTAssertEqual(viewModel.totalResults, 0)
    }
    
    func testLoadMoreMoviesSuccess() async {
        // Given - Set up initial search results
        let initialResults = [
            SearchResult(title: "Batman Begins", year: "2005", imdbID: "tt0372784", type: "movie", poster: "batman1.jpg")
        ]
        mockService.mockSearchResults = initialResults
        mockService.mockTotalResults = 20
        mockService.mockHasMorePages = true
        viewModel.searchText = "Batman"
        await viewModel.searchMovies()
        
        // Set up next page results
        let nextPageResults = [
            SearchResult(title: "The Dark Knight", year: "2008", imdbID: "tt0468569", type: "movie", poster: "batman2.jpg")
        ]
        mockService.mockSearchResults = nextPageResults
        
        // When
        await viewModel.loadMoreMovies()
        
        // Then
        XCTAssertEqual(viewModel.searchResults.count, 2)
        XCTAssertEqual(viewModel.searchResults[0].title, "Batman Begins")
        XCTAssertEqual(viewModel.searchResults[1].title, "The Dark Knight")
        XCTAssertFalse(viewModel.isLoadingMore)
    }
    
    func testLoadMoreMoviesError() async {
        // Given - Set up initial state
        let initialResults = [
            SearchResult(title: "Batman", year: "2005", imdbID: "tt0372784", type: "movie", poster: "batman.jpg")
        ]
        mockService.mockSearchResults = initialResults
        mockService.mockHasMorePages = true
        await viewModel.searchMovies()
        
        // Set error for next page
        mockService.shouldReturnError = true
        
        // When
        await viewModel.loadMoreMovies()
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showingError)
        XCTAssertFalse(viewModel.isLoadingMore)
    }
    
    func testLoadMovieDetailsSuccess() async {
        // Given
        let mockMovie = Movie(
            title: "The Dark Knight",
            year: "2008",
            rated: "PG-13",
            released: "18 Jul 2008",
            runtime: "152 min",
            genre: "Action, Crime, Drama",
            director: "Christopher Nolan",
            writer: "Jonathan Nolan, Christopher Nolan",
            actors: "Christian Bale, Heath Ledger, Aaron Eckhart",
            plot: "When the menace known as the Joker wreaks havoc...",
            language: "English",
            country: "USA",
            awards: "Won 2 Oscars. Another 146 wins & 142 nominations.",
            poster: "https://example.com/poster.jpg",
            ratings: [],
            metascore: "84",
            imdbRating: "9.0",
            imdbVotes: "2,000,000",
            imdbID: "tt0468569",
            type: "movie",
            dvd: "09 Dec 2008",
            boxOffice: "$534,858,444",
            production: "Warner Bros. Pictures",
            website: "http://thedarkknight.warnerbros.com/",
            response: "True"
        )
        
        mockService.mockMovieDetails = mockMovie
        
        let searchResult = SearchResult(
            title: "The Dark Knight",
            year: "2008",
            imdbID: "tt0468569",
            type: "movie",
            poster: "poster.jpg"
        )
        
        // When
        await viewModel.loadMovieDetails(for: searchResult)
        
        // Then
        XCTAssertNotNil(viewModel.selectedMovie)
        XCTAssertEqual(viewModel.selectedMovie?.title, "The Dark Knight")
        XCTAssertEqual(viewModel.selectedMovie?.imdbRating, "9.0")
        XCTAssertFalse(viewModel.isLoadingMovieDetails)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testLoadMovieDetailsError() async {
        // Given
        mockService.shouldReturnError = true
        
        let searchResult = SearchResult(
            title: "Invalid Movie",
            year: "2008",
            imdbID: "invalid",
            type: "movie",
            poster: "poster.jpg"
        )
        
        // When
        await viewModel.loadMovieDetails(for: searchResult)
        
        // Then
        XCTAssertNil(viewModel.selectedMovie)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.showingError)
        XCTAssertFalse(viewModel.isLoadingMovieDetails)
    }

    func testToggleViewLayout() {
        // Test initial state (list)
        XCTAssertEqual(viewModel.viewLayout, .list)
        
        // When
        viewModel.toggleViewLayout()
        
        // Then
        XCTAssertEqual(viewModel.viewLayout, .grid)
        
        // When 
        viewModel.toggleViewLayout()
        
        // Then
        XCTAssertEqual(viewModel.viewLayout, .list)
    }
    
    func testViewLayoutIconNames() {
        XCTAssertEqual(ViewLayout.grid.iconName, "square.grid.2x2")
        XCTAssertEqual(ViewLayout.list.iconName, "list.bullet")
    }
}
