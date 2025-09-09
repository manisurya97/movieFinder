//
//  MovieTests.swift
//  MovieFinderTests
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import XCTest
@testable import MovieFinder

final class MovieTests: XCTestCase {
    
    func testMovieStarRatingCalculation() {
        // When
        let movie1 = Movie(
            title: "Test Movie", year: "2020", rated: "PG", released: "01 Jan 2020",
            runtime: "120 min", genre: "Action", director: "Test Director",
            writer: "Test Writer", actors: "Test Actor", plot: "Test plot",
            language: "English", country: "USA", awards: "None",
            poster: "test.jpg", ratings: [], metascore: "70",
            imdbRating: "8.0", imdbVotes: "1000", imdbID: "tt0000000",
            type: "movie", dvd: nil, boxOffice: nil, production: nil,
            website: nil, response: "True"
        )
        
        // Then
        XCTAssertEqual(movie1.starRating, 4)
        XCTAssertEqual(movie1.starRatingAccessibilityLabel, "4 out of 5 stars")
        
        // When
        let movie2 = Movie(
            title: "Perfect Movie", year: "2020", rated: "PG", released: "01 Jan 2020",
            runtime: "120 min", genre: "Action", director: "Test Director",
            writer: "Test Writer", actors: "Test Actor", plot: "Test plot",
            language: "English", country: "USA", awards: "None",
            poster: "test.jpg", ratings: [], metascore: "100",
            imdbRating: "10.0", imdbVotes: "1000", imdbID: "tt0000001",
            type: "movie", dvd: nil, boxOffice: nil, production: nil,
            website: nil, response: "True"
        )
        
        // Then
        XCTAssertEqual(movie2.starRating, 5)
        
        // When
        let movie3 = Movie(
            title: "Bad Movie", year: "2020", rated: "PG", released: "01 Jan 2020",
            runtime: "120 min", genre: "Action", director: "Test Director",
            writer: "Test Writer", actors: "Test Actor", plot: "Test plot",
            language: "English", country: "USA", awards: "None",
            poster: "test.jpg", ratings: [], metascore: "10",
            imdbRating: "N/A", imdbVotes: "1000", imdbID: "tt0000002",
            type: "movie", dvd: nil, boxOffice: nil, production: nil,
            website: nil, response: "True"
        )
        
        // Then
        XCTAssertEqual(movie3.starRating, 0)
    }
    
    func testSearchResultWithPagination() {
        // Given
        let results = [
            SearchResult(title: "Movie 1", year: "2020", imdbID: "tt1", type: "movie", poster: "poster1.jpg"),
            SearchResult(title: "Movie 2", year: "2021", imdbID: "tt2", type: "movie", poster: "poster2.jpg")
        ]
        
        // When
        let pagination = SearchResultsWithPagination(
            results: results,
            totalResults: 100,
            currentPage: 1,
            hasMorePages: true
        )
        
        // Then
        XCTAssertEqual(pagination.results.count, 2)
        XCTAssertEqual(pagination.totalResults, 100)
        XCTAssertEqual(pagination.currentPage, 1)
        XCTAssertTrue(pagination.hasMorePages)
    }
}
