//
//  MoviesListViewModel.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class MoviesListViewModel {
    
    private weak var coordinator: AppCoorinating?
    private let getAllMoviesUseCase: GetAllMoviesUseCase
    private let disposeBag: DisposeBag
        
    init(
        coordinator: AppCoorinating,
        getAllMoviesUseCase: GetAllMoviesUseCase
    ) {
        self.disposeBag = DisposeBag()
        self.coordinator = coordinator
        self.getAllMoviesUseCase = getAllMoviesUseCase
    }
    
    func fetchMoviesList() {
        self.getAllMoviesUseCase.execute().subscribe { response in
            print(response)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)

    }
}
