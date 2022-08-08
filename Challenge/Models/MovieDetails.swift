//
//  MovieDetails.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation


struct MovieDetailsResponse: Codable {
    let result: MovieDetails
}

struct MovieDetails: Codable {
    let image: String
    let title: String
    let rating: String
    let description: String
    let release: String
    let genres: [MovieGenre]
}

struct MovieGenre: Codable {
    let name: String
}
