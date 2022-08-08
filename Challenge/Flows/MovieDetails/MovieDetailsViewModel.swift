//
//  MovieDetailsViewModel.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift
import RxRelay

class MovieDetailsViewModel {
    
    private var coordinator: AppCoordinating?
    private var getMovieDetailsUseCase: GetMovieDetailsUseCaseImpl
    private let disposeBag: DisposeBag
    private let id: String
    
    private let movie: BehaviorRelay<MovieDetails?>
    var movieObservable: Observable<MovieDetails?> {
        return movie.asObservable()
    }
    
    private let isLoading: BehaviorRelay<Bool>
    var isLoadingObservable: Observable<Bool> {
        return isLoading.asObservable()
    }
    
    private let error: BehaviorRelay<String>
    var errorObservable: Observable<String> {
        return error.asObservable()
    }
    
    init(
        coordinator: AppCoordinating,
        getMovieDetailsUseCase: GetMovieDetailsUseCaseImpl,
        id: String
    ) {
        self.id = id
        self.coordinator = coordinator
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        self.disposeBag = DisposeBag()
        
        self.movie = BehaviorRelay(value: nil)
        self.isLoading = BehaviorRelay(value: false)
        self.error = BehaviorRelay(value: "")
    }
    
    func fetchMovieDetails() {
        self.isLoading.accept(true)
        self.getMovieDetailsUseCase.execute(with: self.id).subscribe { response in
            self.movie.accept(response.result)
            self.isLoading.accept(false)
        } onError: { error in
            self.isLoading.accept(false)
            self.error.accept("An error occured while fetching the data.")
        }.disposed(by: disposeBag)

    }
    
}
