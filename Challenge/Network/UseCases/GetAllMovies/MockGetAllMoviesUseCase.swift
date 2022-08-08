//
//  MockGetAllMoviesUseCase.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class MockGetAllMoviesUseCase: GetAllMoviesUseCase {
    
    init() {}
    
    var response: MovieResponse?
    
    func execute() -> Observable<MovieResponse> {
        if let response = response {
            return .just(response)
        }
        return .error(HTTPError.invalidResponse)
    }
}
