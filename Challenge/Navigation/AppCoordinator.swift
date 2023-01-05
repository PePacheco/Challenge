//
//  AppCoordinator.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit

class AppCoordinator: AppCoordinating {

    var children: [Coordinator]
    var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.children = []
    }
    
    func start() {
        let repository = MoviesRepository()
        let getAllMoviesUseCase = GetAllMoviesUseCaseImpl(repository: repository)
        let viewModel = MoviesListViewModel(coordinator: self, getAllMoviesUseCase: getAllMoviesUseCase)
        let moviesListviewController = MoviesListViewController(viewModel: viewModel)
        navigationController?.setViewControllers([moviesListviewController], animated: true)
    }
    
    func showMovieDetails(with id: Int) {
        let repository = MoviesRepository()
        let getMovieDetailsUseCase = GetMovieDetailsUseCaseImpl(repository: repository)
        let viewModel = MovieDetailsViewModel(coordinator: self, getMovieDetailsUseCase: getMovieDetailsUseCase, id: id)
        let movieDetailsViewController = MovieDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }

}
