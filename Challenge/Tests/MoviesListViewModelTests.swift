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
    
    func testFetchMoviesSuccess() {
        let expected = MovieResponse(results: [
            Movie(id: 1, title: "Test", release_date: "01/01/2000", poster_path: ""),
            Movie(id: 2, title: "Test", release_date: "02/01/2000", poster_path: ""),
            Movie(id: 3, title: "Test", release_date: "03/01/2000", poster_path: "")
        ])
        useCase!.response = expected
        
        viewModel!.errorPublisher.sink{ error in
            XCTAssertEqual(error, "")
        }.store(in: &cancellables!)
        
        viewModel!.moviesPublisher
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies, expected.results)
        }.store(in: &cancellables!)
        
        viewModel!.fetchMoviesList()
        
        

    }
    
    func testFetchMoviesFailure() {
        viewModel!.moviesPublisher.sink { movies in
            XCTAssertEqual(movies.count, 0)
        }.store(in: &cancellables!)
        
        viewModel!.errorPublisher.sink{ error in
            XCTAssertEqual(error, "An error occured while fetching the data.")
        }.store(in: &cancellables!)
        
        viewModel!.fetchMoviesList()
    }
    
    func testGetMovie() {
        useCase!.response = MovieResponse(results: [
            Movie(id: 1, title: "Test", release_date: "01/01/2000", poster_path: ""),
            Movie(id: 2, title: "Test", release_date: "02/01/2000", poster_path: ""),
            Movie(id: 3, title: "Test", release_date: "03/01/2000", poster_path: "")
        ])
        viewModel!.fetchMoviesList()
        
        let movie = viewModel!.getMovie(at: IndexPath(row: 0, section: 0))
        
        XCTAssertEqual(movie.id, 1)
    }
    
    func testShowDetails() {
        useCase!.response = MovieResponse(results: [
            Movie(id: 1, title: "Test", release_date: "01/01/2000", poster_path: ""),
            Movie(id: 2, title: "Test", release_date: "02/01/2000", poster_path: ""),
            Movie(id: 3, title: "Test", release_date: "03/01/2000", poster_path: "")
        ])
        viewModel!.fetchMoviesList()
        
        viewModel!.showDetails(at: IndexPath(row: 0, section: 0))
        
        XCTAssertTrue(coordinator!.hasShowedMovieDetails)
    }

}
