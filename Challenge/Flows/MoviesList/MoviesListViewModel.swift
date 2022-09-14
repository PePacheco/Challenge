//
//  MoviesListViewModel.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import Combine

class MoviesListViewModel {
    
    private var coordinator: AppCoordinating?
    private let getAllMoviesUseCase: GetAllMoviesUseCase
    private var cancellable: AnyCancellable?
    
    private let isLoading: PassthroughSubject<Bool, Never>
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        return isLoading.eraseToAnyPublisher()
    }
    
    private let error: PassthroughSubject<String, Never>
    var errorPublisher: AnyPublisher<String, Never> {
        return error.eraseToAnyPublisher()
    }
    
    private let movies: CurrentValueSubject<[Movie], Never>
    var moviesPublisher: AnyPublisher<[Movie], Never> {
        return movies.eraseToAnyPublisher()
    }
        
    init(
        coordinator: AppCoordinating,
        getAllMoviesUseCase: GetAllMoviesUseCase
    ) {
        self.coordinator = coordinator
        self.getAllMoviesUseCase = getAllMoviesUseCase
        
        self.isLoading = PassthroughSubject<Bool, Never>()
        self.movies = CurrentValueSubject<[Movie], Never>([])
        self.error = PassthroughSubject<String, Never>()
    }
    
    func fetchMoviesList() {
        self.isLoading.send(true)
        
        self.cancellable = self.getAllMoviesUseCase.execute()
            .map(\.results)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished: break
                    case .failure(_):
                        self.isLoading.send(false)
                        self.error.send("Ocorreu um erro ao buscar seus dados.")
                }
            }) { results in
                self.movies.send(results)
                self.isLoading.send(false)
            }
    }
    
    func getMovie(at indexPath: IndexPath) -> Movie {
        return movies.value[indexPath.row]
    }
    
    func showDetails(at indexPath: IndexPath) {
        let id = self.getMovie(at: indexPath)._id
        self.coordinator?.showMovieDetails(with: id)
    }
}
