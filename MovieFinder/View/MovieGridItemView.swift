//
//  MovieGridItemView.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import SwiftUI

struct MovieGridItemView: View {
    let searchResult: SearchResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Movie Poster
            AsyncImage(url: URL(string: searchResult.poster)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title2)
                    )
            }
            .frame(height: 220)
            .clipped()
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            
            // Movie Info
            VStack(alignment: .leading, spacing: 4) {
                Text(searchResult.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    Text(searchResult.year)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(searchResult.type.capitalized)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal, 4)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Movie: \(searchResult.title), Year: \(searchResult.year)")
        .accessibilityHint("Tap to view movie details")
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: 16) {
        MovieGridItemView(searchResult: SearchResult(
            title: "The Dark Knight",
            year: "2008",
            imdbID: "tt0468569",
            type: "movie",
            poster: "https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg"
        ))
        
        MovieGridItemView(searchResult: SearchResult(
            title: "Avengers: Endgame",
            year: "2019",
            imdbID: "tt4154796",
            type: "movie",
            poster: "https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_SX300.jpg"
        ))
    }
    .padding()
}
