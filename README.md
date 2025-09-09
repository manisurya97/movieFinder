# movieFinder

A SwiftUI-based iOS application that allows users to search for movies using the OMDB (Open Movie Database) API. The app displays movie information including title, poster, and a 5-star rating system converted from IMDB ratings.

## Features

- **Popular Movies on Launch**: App loads with popular movies displayed by default
- **Navigation Search**: Search functionality integrated into the navigation bar
- **Grid and List Views**: Toggle between grid and list layouts for movie browsing
- **Pagination Support**: Load more movies with "Load More" functionality for both search and popular results
- **Movie Search**: Search for movies by title using the OMDB API with pagination
- **Movie Details**: View comprehensive movie information including plot, cast, director, and more
- **Star Rating System**: Convert IMDB 10-point ratings to intuitive 5-star ratings
- **Accessibility Support**: Full VoiceOver support for star ratings and navigation
- **Error Handling**: Graceful handling of network errors and "Movie not found" scenarios
- **Pull to Refresh**: Refresh popular movies or search results with pull-to-refresh gesture
- **Results Counter**: Display current results vs total available results
- **Modern UI**: Clean, intuitive interface built with SwiftUI

## Architecture & Design Decisions

### High-Level Architecture

The app follows the MVVM (Model-View-ViewModel) architectural pattern with protocol-oriented programming:

- **Models**: Data structures representing movies and API responses
- **Protocols**: `MovieServiceProtocol` defines the contract for movie data operations
- **NetworkService**: Concrete implementation of `MovieServiceProtocol` handling OMDB API communication
- **MockService**: Test implementation of `MovieServiceProtocol` for unit testing
- **ViewModel**: Manages UI state and coordinates between views and data layer via dependency injection
- **Views**: SwiftUI components for displaying the user interface

### Key Design Decisions

1. **MVVM + Protocol-Oriented Programming**: Chosen for separation of concerns, testability, and dependency injection
2. **Dependency Injection**: ViewModels accept protocols instead of concrete implementations for better testing
3. **Async/Await**: Modern Swift concurrency for network operations
4. **ObservableObject**: SwiftUI's reactive programming paradigm for state management
5. **Modular Views**: Separate view components for better reusability and maintainability
6. **Protocol Abstraction**: `MovieServiceProtocol` enables easy mocking and testing without network calls
7. **Popular Movies Strategy**: Uses curated searches for popular franchises to create engaging default content
8. **Dual Layout Support**: Grid and list views for different user preferences and device orientations
9. **NavigationStack**: Modern navigation with integrated search for iOS 16+ experience

### Star Rating Conversion

The app converts IMDB's 10-point rating system to a 5-star system:
- Formula: `starRating = round(imdbRating / 2.0)`
- Example: 8.1 IMDB rating → 4 stars (8.1 ÷ 2 = 4.05, rounded = 4)
- Handles edge cases like missing ratings ("N/A") or invalid values

## Technical Implementation

### Third-Party Libraries & Tools

This project uses only native iOS frameworks and libraries:
- **SwiftUI**: Modern declarative UI framework
- **Foundation**: Core networking and data handling
- **Swift Testing**: Modern testing framework (iOS 18+)

**Why minimal dependencies?**
- Reduces complexity and potential version conflicts
- Leverages Apple's native, well-optimized frameworks
- Ensures long-term maintainability
- Demonstrates proficiency with core iOS development
- Enables protocol-oriented programming without external abstractions

### API Integration

**OMDB API**: http://www.omdbapi.com/
- **Search Endpoint**: `?apikey={key}&s={title}&type=movie&page={page}`
- **Details Endpoint**: `?apikey={key}&i={imdbID}&plot=full`
- **Pagination**: OMDB returns 10 results per page with totalResults count
- **Popular Movies**: Curated searches across popular franchises (Avengers, Star Wars, Batman, Marvel, Harry Potter)
- **API Key**: `ee60b1cc`

### Pagination Implementation

The app implements comprehensive pagination support:

**Protocol Design**:
```swift
struct SearchResultsWithPagination {
    let results: [SearchResult]
    let totalResults: Int
    let currentPage: Int  
    let hasMorePages: Bool
}
```
**User Experience**:
- Grid view: Load More button spans both columns with visual indicator
- List view: Load More button as a styled row with progress indicator
- Automatic appending of new results to existing list
- No duplicate results (handled by unique IMDB ID filtering)

### Accessibility Features

- **VoiceOver Support**: Star ratings announce as "X out of 5 stars"
- **Accessibility Labels**: Descriptive labels for all interactive elements
- **Accessibility Hints**: Guidance for user interactions
- **Semantic Elements**: Proper accessibility traits for buttons and controls

## Development Process & Time Investment

### Time Breakdown (Estimated 3 hours)

1. **Project Setup & Planning** (30 minutes)
   - Analyzed requirements
   - Set up project structure
   - Planned architecture

2. **Core Implementation** (1.5 hours)
   - Data models and API integration
   - Network service implementation
   - ViewModel logic
   - Core UI components

3. **UI/UX Polish** (45 minutes)
   - Star rating component
   - Movie detail view
   - Error handling and loading states
   - Accessibility improvements

4. **Testing & Documentation** (15 minutes)
   - Unit tests for critical functionality
   - README documentation

### Challenges & Solutions

1. **API Response Handling**: OMDB returns different response structures for search vs. details
   - **Solution**: Created separate models for SearchResponse and Movie details

2. **Rating Conversion Logic**: Ensuring accurate conversion from 10-point to 5-star system
   - **Solution**: Comprehensive unit tests covering edge cases and rounding scenarios

3. **Accessibility**: Making star ratings meaningful for VoiceOver users
   - **Solution**: Custom accessibility labels and proper semantic markup

## Testing Strategy

### Unit Tests Coverage

- **Rating Conversion**: Tests all rating scenarios (0-10 scale to 5-star conversion)
- **Error Handling**: Validates "Movie not found" and network error scenarios using mock services
- **ViewModel Logic**: Tests state management and user interaction flows with dependency injection
- **Protocol Compliance**: Ensures both real and mock services implement the same interface
- **Pagination Logic**: Comprehensive testing of load more functionality and state management
- **Edge Cases**: Invalid ratings, empty searches, network failures, pagination edge cases

### Test Categories

1. **Data Layer Tests**: Model validation and API response parsing
2. **Business Logic Tests**: Rating conversion algorithms
3. **Protocol Tests**: Mock service behavior and dependency injection
4. **Pagination Tests**: Load more functionality, state management, and edge cases
5. **Error Handling Tests**: Network failures and invalid data using controlled mocks
6. **State Management Tests**: ViewModel behavior and UI state with injected dependencies

### Protocol-Oriented Testing Benefits

- **No Network Calls**: Tests run fast without real API dependencies
- **Controlled Environment**: Mock services provide predictable test scenarios
- **Error Simulation**: Easy testing of edge cases and failure scenarios
- **Isolation**: Each test is independent and doesn't affect others

## Future Enhancements

If given unlimited time, potential improvements would include:

1. **Enhanced Search**: 
   - Search filters (year, genre, type)
   - Search history and favorites
   - Advanced search with multiple criteria

2. **Offline Capabilities**:
   - Core Data for local storage
   - Offline viewing of previously searched movies
   - Sync strategies for cached data

3. **UI/UX Improvements**:
   - Dark mode support
   - Custom animations and transitions
   - iPad-optimized layout
   - Landscape orientation support

4. **Additional Features**:
   - Movie trailers integration
   - Similar movies recommendations
   - User ratings and reviews
   - Social sharing functionality

5. **Performance Optimizations**:
   - Image caching system
   - Pagination for search results
   - Background refresh capabilities

## How to Run

1. Open `MovieFinder.xcodeproj` in Xcode
2. Select a target device or simulator (iOS 17.0+)
3. Build and run the project
4. Search for movies using the search field

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## API Documentation

This app integrates with the OMDB API. For more information about the API:
- Website: http://www.omdbapi.com/
- API Documentation: http://www.omdbapi.com/#usage

---

**Developer**: MANI SURYA SAVA  
**Date**: September 2025  
**Framework**: SwiftUI  
**Language**: Swift  

