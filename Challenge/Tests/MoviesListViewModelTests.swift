//
//  MoviesListViewModelTests.swift
//  ChallengeTests
//
//  Created by pedro.pacheco on 08/08/22.
//

import XCTest
import Combine

@testable import Challenge
class MoviesListViewModelTests: XCTestCase {
    
    var viewModel: MoviesListViewModel?
    var useCase: MockGetAllMoviesUseCase?
    var coordinator: MockAppCoordinator?
    var cancellables: [AnyCancellable]? = []

    override func setUp() {
        super.setUp()
        useCase = MockGetAllMoviesUseCase()
        coordinator = MockAppCoordinator()
        viewModel = MoviesListViewModel(coordinator: coordinator!, getAllMoviesUseCase: useCase!)
    }
    
    override func tearDown() {
        viewModel = nil
        coordinator = nil
        useCase = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInit() {
        viewModel!.moviesPublisher.sink { movies in
            XCTAssertEqual(movies.count, 0)
        }.store(in: &cancellables!)
        
        viewModel!.errorPublisher.sink{ error in
            XCTAssertEqual(error, "")
        }.store(in: &cancellables!)
        
        viewModel!.isLoadingPublisher.sink { isLoading in
            XCTAssertFalse(isLoading)
        }.store(in: &cancellables!)
    }
    
    func testFetchMoviesSuccess() {
        useCase!.response = MovieResponse(status: 200, results: [
            Movie(_id: "1", title: "Test", release: "01/01/2000", image: ""),
            Movie(_id: "2", title: "Test", release: "02/01/2000", image: ""),
            Movie(_id: "3", title: "Test", release: "03/01/2000", image: "")
        ])
        viewModel!.fetchMoviesList()
        
        viewModel!.moviesPublisher.sink { movies in
            XCTAssertEqual(movies.count, 3)
        }.store(in: &cancellables!)
        
        viewModel!.errorPublisher.sink{ error in
            XCTAssertEqual(error, "")
        }.store(in: &cancellables!)
    }
    
    func testFetchMoviesFailure() {
        viewModel!.fetchMoviesList()
        
        viewModel!.moviesPublisher.sink { movies in
            XCTAssertEqual(movies.count, 0)
        }.store(in: &cancellables!)
        
        viewModel!.errorPublisher.sink{ error in
            XCTAssertEqual(error, "Ocorreu um erro ao buscar seus dados.")
        }.store(in: &cancellables!)
    }
    
    func testGetMovie() {
        useCase!.response = MovieResponse(status: 200, results: [
            Movie(_id: "1", title: "Test", release: "01/01/2000", image: ""),
            Movie(_id: "2", title: "Test", release: "02/01/2000", image: ""),
            Movie(_id: "3", title: "Test", release: "03/01/2000", image: "")
        ])
        viewModel!.fetchMoviesList()
        
        let movie = viewModel!.getMovie(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(movie._id, "1")
    }
    
    func testShowDetails() {
        useCase!.response = MovieResponse(status: 200, results: [
            Movie(_id: "1", title: "Test", release: "01/01/2000", image: ""),
            Movie(_id: "2", title: "Test", release: "02/01/2000", image: ""),
            Movie(_id: "3", title: "Test", release: "03/01/2000", image: "")
        ])
        viewModel!.fetchMoviesList()
        
        viewModel!.showDetails(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(coordinator!.hasShowedMovieDetails)
    }

}
