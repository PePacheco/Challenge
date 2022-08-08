//
//  GetMovieDetailsUseCase.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import Foundation
import RxSwift

protocol GetMovieDetailsUseCase {
    func execute(with id: String) -> Observable<MovieDetailsResponse>
}
