//
//  Movie.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let id: Int
    let title: String
    let release_date: String
    let poster_path: String
}

extension Movie {
    var image: String {
        return "https://image.tmdb.org/t/p/w500\(poster_path)"
    }
}
