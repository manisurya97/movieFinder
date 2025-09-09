//
//  ContentView.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieSearchViewModel()
    @State private var showingMovieDetail = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    // Loading State
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text(viewModel.isSearching ? "Searching..." : "Loading popular movies...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.searchResults.isEmpty && !viewModel.isLoading {
                    // Empty State
                    VStack(spacing: 20) {
                        Image(systemName: viewModel.isSearching ? "magnifyingglass" : "film")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text(viewModel.isSearching ? "No movies found" : "No movies available")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        Text(viewModel.isSearching ?
                             "Try searching with a different title" :
                             "Pull to refresh or try searching for movies")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Movie Results
                    if viewModel.viewLayout == .grid {
                        // Grid View
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 20) {
                                ForEach(viewModel.searchResults) { result in
                                    MovieGridItemView(searchResult: result)
                                        .onTapGesture {
                                            Task {
                                                await viewModel.loadMovieDetails(for: result)
                                                showingMovieDetail = true
                                            }
                                        }
                                }
                                
                                // Load More Trigger and Loading Indicator for Grid
                                if viewModel.canLoadMore {
                                    VStack {
                                        // Loading indicator
                                        if viewModel.isLoadingMore {
                                            HStack {
                                                Spacer()
                                                ProgressView()
                                                    .scaleEffect(1.2)
                                                    .padding()
                                                Spacer()
                                            }
                                        }
                                        
                                        // Invisible trigger for load more
                                        Color.clear
                                            .frame(height: 1)
                                            .onAppear {
                                                if !viewModel.isLoadingMore {
                                                    Task {
                                                        await viewModel.loadMoreMovies()
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                            .padding()
                        }
                    } else {
                        // List View
                        List {
                            ForEach(viewModel.searchResults) { result in
                                MovieRowView(searchResult: result)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.loadMovieDetails(for: result)
                                            showingMovieDetail = true
                                        }
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                            
                            // Load More Trigger and Loading Indicator for List
                            if viewModel.canLoadMore {
                                VStack {
                                    // Loading indicator
                                    if viewModel.isLoadingMore {
                                        HStack {
                                            Spacer()
                                            ProgressView()
                                                .scaleEffect(1.2)
                                                .padding()
                                            Spacer()
                                        }
                                    }
                                    
                                    // Invisible trigger for load more
                                    Color.clear
                                        .frame(height: 1)
                                        .onAppear {
                                            if !viewModel.isLoadingMore {
                                                Task {
                                                    await viewModel.loadMoreMovies()
                                                }
                                            }
                                        }
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle(viewModel.isSearching ? "Search Results" : "Popular Movies")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $viewModel.searchText,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search for movies..."
            )
            .onSubmit(of: .search) {
                Task {
                    await viewModel.searchMovies()
                }
            }
            .onChange(of: viewModel.searchText) { oldValue, newValue in
                if newValue.isEmpty && !oldValue.isEmpty {
                    Task {
                        await viewModel.searchMovies()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.toggleViewLayout()
                        }
                    }) {
                        Image(systemName: viewModel.viewLayout.iconName)
                            .font(.title3)
                    }
                    .accessibilityLabel("Toggle between grid and list view")
                    .accessibilityValue("Currently showing \(viewModel.viewLayout == .grid ? "grid" : "list") view")
                }
            }
            .refreshable {
                if viewModel.searchText.isEmpty {
                    await viewModel.loadPopularMovies()
                } else {
                    await viewModel.searchMovies()
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK") {
                    viewModel.showingError = false
                }
            } message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred")
            }
            .sheet(isPresented: $showingMovieDetail) {
                if let movie = viewModel.selectedMovie {
                    MovieDetailView(movie: movie)
                }
            }
            .overlay(alignment: .center) {
                if viewModel.isLoadingMovieDetails {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .frame(width: 120, height: 120)
                        .overlay {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .scaleEffect(1.2)
                                Text("Loading...")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .shadow(color: .black.opacity(0.1), radius: 10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
