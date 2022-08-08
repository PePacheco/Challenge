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
    
    private weak var coordinator: AppCoorinating?
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
        coordinator: AppCoorinating,
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
            print(error)
            self.isLoading.accept(false)
            self.error.accept("An error occured while fetching the data.")
        }.disposed(by: disposeBag)

    }
}
