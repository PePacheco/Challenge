//
//  MovieDetailsViewModel.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

class MovieDetailsViewModel {
    
    private var coordinator: AppCoordinating?
    private var getMovieDetailsUseCase: GetMovieDetailsUseCaseImpl
    private let disposeBag: DisposeBag
    private let id: String
    
    init(
        coordinator: AppCoordinating,
        getMovieDetailsUseCase: GetMovieDetailsUseCaseImpl,
        id: String
    ) {
        self.id = id
        self.coordinator = coordinator
        self.getMovieDetailsUseCase = getMovieDetailsUseCase
        self.disposeBag = DisposeBag()
    }
    
    func fetchMovieDetails() {
        self.getMovieDetailsUseCase.execute(with: self.id).subscribe { response in
            print(response)
        } onError: { error in
            print(error)
        }.disposed(by: disposeBag)

    }
    
}
