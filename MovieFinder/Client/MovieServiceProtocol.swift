//
//  MovieServiceProtocol.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import Foundation

// MARK: - Search Result with Pagination
struct SearchResultsWithPagination {
    let results: [SearchResult]
    let totalResults: Int
    let currentPage: Int
    let hasMorePages: Bool
}

// MARK: - Movie Service Protocol
protocol MovieServiceProtocol {
    /// Search for movies by title with pagination support
    /// - Parameters:
    ///   - title: The movie title to search for
    ///   - page: The page number to fetch (default: 1)
    /// - Returns: Search results with pagination information
    /// - Throws: NetworkError for various failure cases
    func searchMovies(title: String, page: Int) async throws -> SearchResultsWithPagination
    
    /// Get detailed information for a specific movie
    /// - Parameter imdbID: The IMDB ID of the movie
    /// - Returns: Detailed movie information
    /// - Throws: NetworkError for various failure cases
    func getMovieDetails(imdbID: String) async throws -> Movie
    
    /// Get a curated list of popular movies with pagination support
    /// - Parameter page: The page number to fetch (default: 1)
    /// - Returns: Popular movie search results with pagination information
    /// - Throws: NetworkError for various failure cases
    func getPopularMovies(page: Int) async throws -> SearchResultsWithPagination
}
