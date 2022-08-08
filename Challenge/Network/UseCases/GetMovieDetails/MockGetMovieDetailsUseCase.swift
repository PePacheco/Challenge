//
//  MockGetMovieDetailsUseCase.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class MockGetMovieDetailsUseCase: GetMovieDetailsUseCase {
    init() {}
    
    var response: MovieDetailsResponse?
    
    func execute(with id: String) -> Observable<MovieDetailsResponse> {
        if let response = response {
            return .just(response)
        }
        return .error(HTTPError.invalidResponse)
    }
}
