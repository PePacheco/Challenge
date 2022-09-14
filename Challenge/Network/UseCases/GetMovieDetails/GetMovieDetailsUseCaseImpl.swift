//
//  GetMovieDetailsUseCaseImpl.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

class GetMovieDetailsUseCaseImpl: GetMovieDetailsUseCase {
    
    let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func execute(with id: String) -> AnyPublisher<MovieDetailsResponse, APIError> {
        return repository.getMovieDetails(with: id)
    }
}
