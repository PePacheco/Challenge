//
//  Movie.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation

struct MovieResponse: Codable {
    let status: Int
    let results: [Movie]
}

struct Movie: Codable, Equatable {
    let _id: String
    let title: String
    let release: String
    let image: String
    
    
}
