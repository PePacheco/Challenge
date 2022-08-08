//
//  AppCoordinator.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit

class AppCoordinator: AppCoorinating {

    var children: [Coordinator]
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.children = []
    }
    
    func start() {
        let repository = MoviesRepository()
        let getAllMoviesUseCase = GetAllMoviesUseCaseImpl(repository: repository)
        let viewModel = MoviesListViewModel(coordinator: self, getAllMoviesUseCase: getAllMoviesUseCase)
        let moviesListviewController = MoviesListViewController(viewModel: viewModel)
        navigationController.setViewControllers([moviesListviewController], animated: true)
    }

}
