//
//  GetAllMoviesUseCaseImpl.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

class GetAllMoviesUseCaseImpl: GetAllMoviesUseCase {
    
    let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<MovieResponse, APIError> {
        return repository.getAllMovies()
    }
}
