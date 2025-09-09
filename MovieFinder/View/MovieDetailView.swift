//
//  MovieDetailView.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header with poster and basic info
                    HStack(alignment: .top, spacing: 16) {
                        AsyncImage(url: URL(string: movie.poster)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                        .font(.title)
                                )
                        }
                        .frame(width: 150, height: 225)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .lineLimit(3)
                            
                            Text(movie.year)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(movie.rated)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            
                            Spacer()
                        }
                    }
                    
                    // Star Rating
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Rating")
                            .font(.headline)
                        
                        HStack {
                            StarRatingView(rating: movie.starRating)
                            Text("(\(movie.imdbRating)/10)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Plot
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Plot")
                            .font(.headline)
                        
                        Text(movie.plot)
                            .font(.body)
                    }
                    
                    // Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Details")
                            .font(.headline)
                        
                        DetailRow(title: "Director", value: movie.director)
                        DetailRow(title: "Writers", value: movie.writer)
                        DetailRow(title: "Actors", value: movie.actors)
                        DetailRow(title: "Genre", value: movie.genre)
                        DetailRow(title: "Runtime", value: movie.runtime)
                        DetailRow(title: "Released", value: movie.released)
                        DetailRow(title: "Language", value: movie.language)
                        DetailRow(title: "Country", value: movie.country)
                        
                        if !movie.awards.isEmpty && movie.awards != "N/A" {
                            DetailRow(title: "Awards", value: movie.awards)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Movie Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        if !value.isEmpty && value != "N/A" {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
            }
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie(
        title: "The Dark Knight",
        year: "2008",
        rated: "PG-13",
        released: "18 Jul 2008",
        runtime: "152 min",
        genre: "Action, Crime, Drama",
        director: "Christopher Nolan",
        writer: "Jonathan Nolan, Christopher Nolan, David S. Goyer",
        actors: "Christian Bale, Heath Ledger, Aaron Eckhart",
        plot: "When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.",
        language: "English, Mandarin",
        country: "United States, United Kingdom",
        awards: "Won 2 Oscars. 164 wins & 164 nominations total",
        poster: "https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg",
        ratings: [],
        metascore: "84",
        imdbRating: "9.0",
        imdbVotes: "2,758,063",
        imdbID: "tt0468569",
        type: "movie",
        dvd: "09 Dec 2008",
        boxOffice: "$534,858,444",
        production: "Warner Brothers, Legendary Entertainment, Syncopy",
        website: "N/A",
        response: "True"
    ))
}
