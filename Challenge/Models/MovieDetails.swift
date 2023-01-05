//
//  MovieDetails.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation

struct MovieDetails: Codable {
    let poster_path: String
    let title: String
    let overview: String
    let release_date: String
    let genres: [MovieGenre]
}

extension MovieDetails {
    var image: String {
        return "https://image.tmdb.org/t/p/w500\(poster_path)"
    }
}

struct MovieGenre: Codable {
    let name: String
}
