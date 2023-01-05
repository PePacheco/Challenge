//
//  MoviesRepository.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

class MoviesRepository {
    
    let client: HTTPClient
    private let apiKey = "84409706477b6eec19f50e5fe64c664c"
    
    init() {
        let headers = [
            "X-RapidAPI-Key": "aa7fd08df3msh3ca988fb3e05b7ap1bb334jsn4f34a423852b"
        ]
        self.client = HTTPClient(withHeaders: headers)
    }
    
    func getAllMovies() -> AnyPublisher<MovieResponse, APIError> {
        let publisher: AnyPublisher<MovieResponse, APIError> = self.client.get(url: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)")
        return publisher
    }
    
    func getMovieDetails(with id: String) -> AnyPublisher<MovieDetails, APIError> {
        let publisher: AnyPublisher<MovieDetails, APIError> = self.client.get(url: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)")
        return publisher
    }
    
}
