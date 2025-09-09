//
//  MockMovieService.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

@testable import MovieFinder

// MARK: - Mock Implementation for Testing
class MockMovieService: MovieServiceProtocol {
    var shouldReturnError = false
    var mockSearchResults: [SearchResult] = []
    var mockMovieDetails: Movie?
    var mockPopularMovies: [SearchResult] = []
    var mockTotalResults = 0
    var mockHasMorePages = false
    
    func searchMovies(title: String, page: Int = 1) async throws -> SearchResultsWithPagination {
        if shouldReturnError {
            throw NetworkError.movieNotFound
        }
        
        if title.isEmpty {
            throw NetworkError.invalidInput
        }
        
        return SearchResultsWithPagination(
            results: mockSearchResults,
            totalResults: mockTotalResults,
            currentPage: page,
            hasMorePages: mockHasMorePages
        )
    }
    
    func getMovieDetails(imdbID: String) async throws -> Movie {
        if shouldReturnError {
            throw NetworkError.movieNotFound
        }
        
        guard let movie = mockMovieDetails else {
            throw NetworkError.movieNotFound
        }
        
        return movie
    }
    
    func getPopularMovies(page: Int = 1) async throws -> SearchResultsWithPagination {
        if shouldReturnError {
            throw NetworkError.networkUnavailable
        }
        
        return SearchResultsWithPagination(
            results: mockPopularMovies,
            totalResults: mockTotalResults,
            currentPage: page,
            hasMorePages: mockHasMorePages
        )
    }
}
