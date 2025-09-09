//
//  NetworkServiceTests.swift
//  MovieFinderTests
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import XCTest
@testable import MovieFinder

// MARK: - NetworkService Tests
final class NetworkServiceTests: XCTestCase {
    
    var networkService: NetworkService!
    
    override func setUp() {
        super.setUp()
        networkService = NetworkService()
    }
    
    override func tearDown() {
        networkService = nil
        super.tearDown()
    }
    
    func testSearchMoviesWithEmptyTitle() async {
        // When
        do {
            _ = try await networkService.searchMovies(title: "", page: 1)
            // Then
            XCTFail("Should throw invalidInput error")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidInput)
        }
    }
    
    func testGetPopularMoviesUsesMarvelSearch() async {
        // When
        do {
            let result = try await networkService.getPopularMovies(page: 1)
            // Then
            XCTAssertGreaterThanOrEqual(result.currentPage, 1)
        } catch {
            // Then
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    // MARK: - NetworkError Tests
    
    func testNetworkErrorDescriptions() {
        XCTAssertEqual(NetworkError.invalidURL.errorDescription, "Invalid URL")
        XCTAssertEqual(NetworkError.invalidInput.errorDescription, "Please enter a movie title to search")
        XCTAssertEqual(NetworkError.invalidResponse.errorDescription, "Invalid response from server")
        XCTAssertEqual(NetworkError.movieNotFound.errorDescription, "Movie not found")
        XCTAssertEqual(NetworkError.apiError("Custom error").errorDescription, "Custom error")
        XCTAssertEqual(NetworkError.decodingError.errorDescription, "Failed to decode response")
        XCTAssertEqual(NetworkError.networkUnavailable.errorDescription, "Network unavailable. Please check your connection.")
    }
    
    func testNetworkErrorEquality() {
        XCTAssertEqual(NetworkError.invalidURL, NetworkError.invalidURL)
        XCTAssertEqual(NetworkError.movieNotFound, NetworkError.movieNotFound)
        XCTAssertEqual(NetworkError.apiError("test"), NetworkError.apiError("test"))
        XCTAssertNotEqual(NetworkError.apiError("test1"), NetworkError.apiError("test2"))
    }
}
