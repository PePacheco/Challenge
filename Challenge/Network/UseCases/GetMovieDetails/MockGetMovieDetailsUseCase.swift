//
//  MockGetMovieDetailsUseCase.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

class MockGetMovieDetailsUseCase: GetMovieDetailsUseCase {
    init() {}
    
    var response: MovieDetails?
    
    func execute(with id: String) -> AnyPublisher<MovieDetails, APIError> {
        if let response = response {
            return Just(response)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.decodingFailed).eraseToAnyPublisher()
    }
}
