//
//  MoviesListViewController.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit
import RxSwift

class MoviesListViewController: UIViewController {
    
    private let viewModel: MoviesListViewModel
    private let disposeBag: DisposeBag
        
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchMoviesList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }


}
