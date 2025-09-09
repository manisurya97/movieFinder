//
//  MovieFinderViewModel.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import Foundation

enum ViewLayout: CaseIterable {
    case grid
    case list
    
    var iconName: String {
        switch self {
        case .grid: return "square.grid.2x2"
        case .list: return "list.bullet"
        }
    }
}

@MainActor
class MovieSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [SearchResult] = []
    @Published var selectedMovie: Movie?
    @Published var isLoading = false
    @Published var isLoadingMovieDetails = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var showingError = false
    @Published var viewLayout: ViewLayout = .list
    @Published var isSearching = false
    @Published var canLoadMore = false
    @Published var totalResults = 0
    
    private let movieService: MovieServiceProtocol
    private var currentPage = 1
    private var currentSearchTerm = ""
    
    init(movieService: MovieServiceProtocol = NetworkService()) {
        self.movieService = movieService
        Task {
            await loadPopularMovies()
        }
    }
    
    // MARK: - Data Loading Functions
    func loadPopularMovies() async {
        isLoading = true
        errorMessage = nil
        showingError = false
        currentPage = 1
        currentSearchTerm = ""
        isSearching = false
        
        do {
            let paginatedResults = try await movieService.getPopularMovies(page: currentPage)
            searchResults = paginatedResults.results
            totalResults = paginatedResults.totalResults
            canLoadMore = paginatedResults.hasMorePages
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoading = false
    }
    
    // MARK: - Search Functions
    func searchMovies() async {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // If search text is empty, reload popular movies
            isSearching = false
            await loadPopularMovies()
            return
        }
        
        isLoading = true
        isSearching = true
        errorMessage = nil
        showingError = false
        currentPage = 1
        currentSearchTerm = searchText
        
        do {
            let paginatedResults = try await movieService.searchMovies(title: searchText, page: currentPage)
            searchResults = paginatedResults.results
            totalResults = paginatedResults.totalResults
            canLoadMore = paginatedResults.hasMorePages
            
            if paginatedResults.results.isEmpty {
                errorMessage = "Movie not found"
                showingError = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
            searchResults = []
            canLoadMore = false
            totalResults = 0
        }
        
        isLoading = false
    }
    
    // MARK: - Pagination Functions
    func loadMoreMovies() async {
        guard canLoadMore && !isLoadingMore && !isLoading else { return }
        
        isLoadingMore = true
        errorMessage = nil
        
        let nextPage = currentPage + 1
        
        do {
            let paginatedResults: SearchResultsWithPagination
            
            if isSearching {
                paginatedResults = try await movieService.searchMovies(title: currentSearchTerm, page: nextPage)
            } else {
                paginatedResults = try await movieService.getPopularMovies(page: nextPage)
            }
            
            // Append new results to existing ones
            searchResults.append(contentsOf: paginatedResults.results)
            canLoadMore = paginatedResults.hasMorePages
            currentPage = nextPage
            
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoadingMore = false
    }
    
    func loadMovieDetails(for searchResult: SearchResult) async {
        isLoadingMovieDetails = true
        errorMessage = nil
        
        do {
            let movie = try await movieService.getMovieDetails(imdbID: searchResult.imdbID)
            selectedMovie = movie
        } catch {
            errorMessage = error.localizedDescription
            showingError = true
        }
        
        isLoadingMovieDetails = false
    }
    
    func clearResults() {
        searchResults = []
        selectedMovie = nil
        errorMessage = nil
        showingError = false
        isSearching = false
        searchText = ""
        canLoadMore = false
        totalResults = 0
        currentPage = 1
        currentSearchTerm = ""
        Task {
            await loadPopularMovies()
        }
    }
    
    func clearSelectedMovie() {
        selectedMovie = nil
    }
    
    func toggleViewLayout() {
        viewLayout = viewLayout == .grid ? .list : .grid
    }
}
