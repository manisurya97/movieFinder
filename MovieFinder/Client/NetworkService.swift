//
//  NetworkService.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import Foundation

// MARK: - NetworkService
class NetworkService: MovieServiceProtocol {
    private let apiKey = "ee60b1cc"
    private let baseURL = "https://www.omdbapi.com/"
    
    // MARK: - Search Movies
    func searchMovies(title: String, page: Int = 1) async throws -> SearchResultsWithPagination {
        guard !title.isEmpty else {
            throw NetworkError.invalidInput
        }
        
        let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "\(baseURL)?apikey=\(apiKey)&s=\(encodedTitle)&type=movie&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
            
            if searchResponse.response == "False" {
                if searchResponse.error?.contains("not found") == true {
                    throw NetworkError.movieNotFound
                }
                throw NetworkError.apiError(searchResponse.error ?? "Unknown error")
            }
            
            let results = searchResponse.search ?? []
            let totalResults = Int(searchResponse.totalResults ?? "0") ?? 0
            let resultsPerPage = 10 // OMDB returns 10 results per page
            let totalPages = (totalResults + resultsPerPage - 1) / resultsPerPage // Ceiling division
            let hasMorePages = page < totalPages
            
            return SearchResultsWithPagination(
                results: results,
                totalResults: totalResults,
                currentPage: page,
                hasMorePages: hasMorePages
            )
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    // MARK: - Get Popular Movies
    func getPopularMovies(page: Int = 1) async throws -> SearchResultsWithPagination {
        // Since OMDB doesn't have a "popular" endpoint, we'll use a single popular search term
        // and let OMDB handle the pagination naturally
        let searchTerm = "Marvel"
        
        // Use OMDB's natural pagination - each page returns up to 10 results
        let searchResults = try await searchMovies(title: searchTerm, page: page)
        
        return SearchResultsWithPagination(
            results: searchResults.results,
            totalResults: searchResults.totalResults,
            currentPage: page,
            hasMorePages: searchResults.hasMorePages
        )
    }
    
    // MARK: - Get Movie Details
    func getMovieDetails(imdbID: String) async throws -> Movie {
        let urlString = "\(baseURL)?apikey=\(apiKey)&i=\(imdbID)&plot=full"
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NetworkError.invalidResponse
            }
            
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            
            if movie.response == "False" {
                throw NetworkError.movieNotFound
            }
            
            return movie
            
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.decodingError
        }
    }
}

// MARK: - Network Errors
enum NetworkError: LocalizedError, Equatable {
    case invalidURL
    case invalidInput
    case invalidResponse
    case movieNotFound
    case apiError(String)
    case decodingError
    case networkUnavailable
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidInput:
            return "Please enter a movie title to search"
        case .invalidResponse:
            return "Invalid response from server"
        case .movieNotFound:
            return "Movie not found"
        case .apiError(let message):
            return message
        case .decodingError:
            return "Failed to decode response"
        case .networkUnavailable:
            return "Network unavailable. Please check your connection."
        }
    }
}
