//
//  MockAppCoordinator.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit

class MockAppCoordinator: AppCoordinating {
    var children: [Coordinator]
    
    var hasStarted = false
    var hasShowedMovieDetails = false
    
    var navigationController: UINavigationController?
    
    init() {
        self.children = []
    }
    
    func start() {
        self.hasStarted = true
    }
    
    func showMovieDetails(with id: Int) {
        self.hasShowedMovieDetails = true
    }
    
}
