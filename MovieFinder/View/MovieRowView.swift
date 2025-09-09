//
//  MovieRowView.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import SwiftUI

struct MovieRowView: View {
    let searchResult: SearchResult
    
    var body: some View {
        HStack {
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
                    )
            }
            .frame(width: 60, height: 90)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(searchResult.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(searchResult.year)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(searchResult.type.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MovieRowView(searchResult: SearchResult(
        title: "The Dark Knight",
        year: "2008",
        imdbID: "tt0468569",
        type: "movie",
        poster: "https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_SX300.jpg"
    ))
    .padding()
}
