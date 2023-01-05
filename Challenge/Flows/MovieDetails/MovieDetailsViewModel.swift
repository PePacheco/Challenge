//
//  MovieDetailsViewModel.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

class MovieDetailsViewModel {
    
    private var coordinator: AppCoordinating?
    private var getMovieDetailsUseCase: GetMovieDetailsUseCase
    private let id: String
    private var cancellable: AnyCancellable?
    
    private let movie: PassthroughSubject<MovieDetails, Never>
    var moviePublisher: AnyPublisher<MovieDetails, Never> {
        return movie.eraseToAnyPublisher()
    }
    
    private let isLoading: PassthroughSubject<Bool, Never>
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    private let error: PassthroughSubject<String, Never>
    var errorPublisher: AnyPublisher<String, Never> {
        return error.eraseToAnyPublisher()
    }
    
    init(
        coordinator: AppCoordinating,
        getMovieDetailsUseCase: GetMovieDetailsUseCase,
        id: String
    ) {
        self.id = id
        self.coordinator = coordinator
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        
        self.isLoading = PassthroughSubject<Bool, Never>()
        self.movie = PassthroughSubject<MovieDetails, Never>()
        self.error = PassthroughSubject<String, Never>()
    }
    
    func fetchMovieDetails() {
        self.isLoading.send(true)
        
        self.cancellable = self.getMovieDetailsUseCase.execute(with: self.id)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished: break
                    case .failure(_):
                        self.isLoading.send(false)
                        self.error.send("An error occured while fetching the data.")
                }
            }) { response in
                self.movie.send(response.result)
                self.isLoading.send(false)
            }

    }
    
}
