//
//  MoviesListViewModel.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift
import RxRelay

class MoviesListViewModel {
    
    private var coordinator: AppCoordinating?
    private let getAllMoviesUseCase: GetAllMoviesUseCase
    private let disposeBag: DisposeBag
    
    private let isLoading: BehaviorRelay<Bool>
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    private let error: BehaviorRelay<String>
    var errorObservable: Observable<String> {
        return error.asObservable()
    }
    
    private let movies: BehaviorRelay<[Movie]>
    var moviesObservable: Observable<[Movie]> {
        return movies.asObservable()
    }
        
    init(
        coordinator: AppCoordinating,
        getAllMoviesUseCase: GetAllMoviesUseCase
    ) {
        self.disposeBag = DisposeBag()
        self.coordinator = coordinator
        self.getAllMoviesUseCase = getAllMoviesUseCase
        
        self.isLoading = BehaviorRelay(value: false)
        self.movies = BehaviorRelay(value: [])
        self.error = BehaviorRelay(value: "")
    }
    
    func fetchMoviesList() {
        self.isLoading.accept(true)
        self.getAllMoviesUseCase.execute().subscribe { response in
            self.movies.accept(response.results)
            self.isLoading.accept(false)
        } onError: { error in
            self.isLoading.accept(false)
            self.error.accept("Ocorreu um erro ao buscar seus dados.")
        }.disposed(by: disposeBag)
    }
    
    func getMovie(at indexPath: IndexPath) -> Movie {
        return movies.value[indexPath.row]
    }
    
    func showDetails(at indexPath: IndexPath) {
        let id = self.getMovie(at: indexPath)._id
        self.coordinator?.showMovieDetails(with: id)
    }
}
