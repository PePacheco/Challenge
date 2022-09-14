//
//  MockGetAllMoviesUseCase.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

class MockGetAllMoviesUseCase: GetAllMoviesUseCase {
    
    init() {}
    
    var response: MovieResponse?
    
    func execute() -> AnyPublisher<MovieResponse, APIError> {
        if let response = response {
            return Just(response)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: APIError.decodingFailed)
            .eraseToAnyPublisher()
    }
}
