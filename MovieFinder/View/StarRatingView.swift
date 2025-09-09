//
//  StarRatingView.swift
//  MovieFinder
//
//  Created by MANI SURYA SAVA on 9/9/25.
//

import SwiftUI

struct StarRatingView: View {
    let rating: Int
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundColor(index <= rating ? .yellow : .gray)
                    .font(.title2)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(rating) out of \(maxRating) stars")
        .accessibilityValue("Movie rating")
        .accessibilityHint("Double tap to hear rating again")
        .accessibilityAddTraits(.updatesFrequently) // Indicates this is dynamic content
    }
}

#Preview {
    VStack(spacing: 20) {
        StarRatingView(rating: 0)
        StarRatingView(rating: 1)
        StarRatingView(rating: 2)
        StarRatingView(rating: 3)
        StarRatingView(rating: 4)
        StarRatingView(rating: 5)
    }
    .padding()
}
