//
//  GetAllMoviesUseCaseImpl.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class GetAllMoviesUseCaseImpl: GetAllMoviesUseCase {
    
    let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func execute() -> Observable<MovieResponse> {
        return repository.getAllMovies()
    }
}
