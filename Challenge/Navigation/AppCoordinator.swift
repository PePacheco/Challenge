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
        let viewModel = MoviesListViewModel(coordinator: self)
        let moviesListviewController = MoviesListViewController(viewModel: viewModel)
        navigationController.setViewControllers([moviesListviewController], animated: true)
    }

    
}
