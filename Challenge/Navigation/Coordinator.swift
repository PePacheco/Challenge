//
//  Coordinator.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit

public protocol Coordinator: AnyObject {
    var children: [Coordinator] { get }
    var navigationController: UINavigationController { get set }
    func start()
}
