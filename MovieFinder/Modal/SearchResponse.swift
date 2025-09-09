//
//  SearchResponse.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import Foundation

// MARK: - Search Response Model
struct SearchResponse: Codable {
    let search: [SearchResult]?
    let totalResults: String?
    let response: String
    let error: String?
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
        case error = "Error"
    }
}

struct SearchResult: Codable, Identifiable {
    let id = UUID()
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
