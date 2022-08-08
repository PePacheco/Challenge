//
//  MoviesListViewModelTests.swift
//  ChallengeTests
//
//  Created by pedro.pacheco on 08/08/22.
//

import XCTest
import RxSwift
import RxCocoa

@testable import Challenge
class MoviesListViewModelTests: XCTestCase {
    
    var viewModel: MoviesListViewModel?
    var useCase: MockGetAllMoviesUseCase?
    var coordinator: MockAppCoordinator?
    var disposeBag: DisposeBag?

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        useCase = MockGetAllMoviesUseCase()
        coordinator = MockAppCoordinator()
        viewModel = MoviesListViewModel(coordinator: coordinator!, getAllMoviesUseCase: useCase!)
    }
    
    override func tearDown() {
        viewModel = nil
        coordinator = nil
        useCase = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testInit() {
        viewModel!.moviesObservable.bind { movies in
            XCTAssertEqual(movies.count, 0)
        }.disposed(by: disposeBag!)
        
        viewModel!.errorObservable.bind{ error in
            XCTAssertEqual(error, "")
        }.disposed(by: disposeBag!)
        
        viewModel!.isLoadingObservable.bind { isLoading in
            XCTAssertFalse(isLoading)
        }.disposed(by: disposeBag!)
    }
    
    func testFetchMoviesSuccess() {
        useCase!.response = MovieResponse(status: 200, results: [
            Movie(_id: "1", title: "Test", release: "01/01/2000", image: ""),
            Movie(_id: "2", title: "Test", release: "02/01/2000", image: ""),
            Movie(_id: "3", title: "Test", release: "03/01/2000", image: "")
        ])
        viewModel!.fetchMoviesList()
        
        viewModel!.moviesObservable.bind { movies in
            XCTAssertEqual(movies.count, 3)
        }.disposed(by: disposeBag!)
        
        viewModel!.errorObservable.bind{ error in
            XCTAssertEqual(error, "")
        }.disposed(by: disposeBag!)
    }
    
    func testFetchMoviesFailure() {
        viewModel!.fetchMoviesList()
        
        viewModel!.moviesObservable.bind { movies in
            XCTAssertEqual(movies.count, 0)
        }.disposed(by: disposeBag!)
        
        viewModel!.errorObservable.bind{ error in
            XCTAssertEqual(error, "Ocorreu um erro ao buscar seus dados.")
        }.disposed(by: disposeBag!)
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
