//
//  MovieDetailsViewModelTests.swift
//  ChallengeTests
//
//  Created by pedro.pacheco on 08/08/22.
//

import XCTest
import RxSwift

@testable import Challenge
class MovieDetailsViewModelTests: XCTestCase {

    var viewModel: MovieDetailsViewModel?
    var useCase: MockGetMovieDetailsUseCase?
    var coordinator: MockAppCoordinator?
    var disposeBag: DisposeBag?

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        useCase = MockGetMovieDetailsUseCase()
        coordinator = MockAppCoordinator()
        viewModel = MovieDetailsViewModel(coordinator: coordinator!, getMovieDetailsUseCase: useCase!, id: "dh0319h1")
    }
    
    override func tearDown() {
        viewModel = nil
        coordinator = nil
        useCase = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testInit() {
        viewModel!.movieObservable.bind { movie in
            XCTAssertNil(movie)
        }.disposed(by: disposeBag!)
        
        viewModel!.errorObservable.bind{ error in
            XCTAssertEqual(error, "")
        }.disposed(by: disposeBag!)
        
        viewModel!.isLoadingObservable.bind { isLoading in
            XCTAssertFalse(isLoading)
        }.disposed(by: disposeBag!)
    }
    
    func testFetchMovieDetailsSuccess() {
        useCase!.response = MovieDetailsResponse(result: MovieDetails(image: "image.jpg", title: "Title", rating: "6/10", description: "Description", release: "10/01/1992", genres: []))
        viewModel!.fetchMovieDetails()
        
        viewModel!.movieObservable.bind { movie in
            guard let movie = movie else {
                XCTAssertTrue(false)
                return
            }
            XCTAssertEqual(movie.title, "Title")
        }.disposed(by: disposeBag!)
    }
    
    func testFetchMovieDetailsFailure() {
        viewModel!.fetchMovieDetails()
        
        viewModel!.movieObservable.bind { movie in
            XCTAssertNil(movie)
        }.disposed(by: disposeBag!)
        
        viewModel!.errorObservable.bind { error in
            XCTAssertEqual(error, "Ocorreu um erro ao buscar seus dados.")
        }.disposed(by: disposeBag!)
    }

}
