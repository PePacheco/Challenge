//
//  GetMovieDetailsUseCaseImpl.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class GetMovieDetailsUseCaseImpl: GetMovieDetailsUseCase {
    
    let repository: MoviesRepository
    
    init(repository: MoviesRepository) {
        self.repository = repository
    }
    
    func execute(with id: String) -> Observable<MovieDetailsResponse> {
        return repository.getMovieDetails(with: id)
    }
}
