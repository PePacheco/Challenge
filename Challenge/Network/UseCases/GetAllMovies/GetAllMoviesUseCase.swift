//
//  GetAllMoviesUseCase.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

protocol GetAllMoviesUseCase {
    func execute() -> AnyPublisher<MovieResponse, APIError>
}
