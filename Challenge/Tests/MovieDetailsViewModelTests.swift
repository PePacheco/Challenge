//
//  MovieDetailsViewModelTests.swift
//  ChallengeTests
//
//  Created by pedro.pacheco on 08/08/22.
//

import XCTest
import Combine

@testable import Challenge
class MovieDetailsViewModelTests: XCTestCase {

    var viewModel: MovieDetailsViewModel?
    var useCase: MockGetMovieDetailsUseCase?
    var coordinator: MockAppCoordinator?
    var cancellables: [AnyCancellable]?

    override func setUp() {
        super.setUp()
        cancellables = []
        useCase = MockGetMovieDetailsUseCase()
        coordinator = MockAppCoordinator()
        viewModel = MovieDetailsViewModel(coordinator: coordinator!, getMovieDetailsUseCase: useCase!, id: "dh0319h1")
    }
    
    override func tearDown() {
        viewModel = nil
        coordinator = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInit() {
        viewModel!.moviePublisher.sink { movie in
            XCTAssertNil(movie)
        }.store(in: &cancellables!)
        
        viewModel!.errorPublisher.sink{ error in
            XCTAssertEqual(error, "")
        }.store(in: &cancellables!)
        
        viewModel!.isLoadingPublisher.sink { isLoading in
            XCTAssertFalse(isLoading)
        }.store(in: &cancellables!)
    }
    
    func testFetchMovieDetailsSuccess() {
        useCase!.response = MovieDetailsResponse(result: MovieDetails(image: "image.jpg", title: "Title", rating: "6/10", description: "Description", release: "10/01/1992", genres: []))
        viewModel!.fetchMovieDetails()
        
        viewModel!.moviePublisher.sink { movie in
            XCTAssertEqual(movie.title, "Title")
        }.store(in: &cancellables!)
    }
    
    func testFetchMovieDetailsFailure() {
        viewModel!.fetchMovieDetails()
        
        viewModel!.moviePublisher.sink { movie in
            XCTAssertNil(movie)
        }.store(in: &cancellables!)
        
        viewModel!.errorPublisher.sink { error in
            XCTAssertEqual(error, "Ocorreu um erro ao buscar seus dados.")
        }.store(in: &cancellables!)
    }

}
