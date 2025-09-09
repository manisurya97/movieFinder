//
//  Movie.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import Foundation

// MARK: - Movie Data Model
struct Movie: Codable, Identifiable {
    let id = UUID()
    let title: String
    let year: String
    let rated: String
    let released: String
    let runtime: String
    let genre: String
    let director: String
    let writer: String
    let actors: String
    let plot: String
    let language: String
    let country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore: String
    let imdbRating: String
    let imdbVotes: String
    let imdbID: String
    let type: String
    let dvd: String?
    let boxOffice: String?
    let production: String?
    let website: String?
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating
        case imdbVotes
        case imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
    }
    
    // Computed property to convert IMDB rating to 5-star system
    var starRating: Int {
        guard let rating = Double(imdbRating), rating > 0 else { return 0 }
        // Convert 10-point scale to 5-star scale and round to nearest whole number
        return Int(round(rating / 2.0))
    }
    
    // Generate star rating string with emojis
    var starRatingString: String {
        let filledStars = starRating
        let emptyStars = 5 - filledStars
        return String(repeating: "⭐", count: filledStars) + String(repeating: "☆", count: emptyStars)
    }
    
    // Accessibility description for star rating
    var starRatingAccessibilityLabel: String {
        return "\(starRating) out of 5 stars"
    }
}

struct Rating: Codable {
    let source: String
    let value: String
    
    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}
