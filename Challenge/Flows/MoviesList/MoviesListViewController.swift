//
//  MoviesListViewController.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesListViewController: UIViewController {
    
    private let viewModel: MoviesListViewModel
    private let disposeBag: DisposeBag
    private var movies: [Movie] = [] {
        didSet {
            print(movies)
        }
    }
        
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
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.isLoadingObservable.bind { isLoading in
            if isLoading {
                DispatchQueue.main.async {
                    self.presentLoadingScreen()
                }
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            }
        }.disposed(by: disposeBag)
        
        self.viewModel.errorObservable.bind { error in
            if !error.isEmpty {
                DispatchQueue.main.async {
                    self.presentAlert(message: error, title: "Oops")
                }
            }
        }.disposed(by: disposeBag)
        
        self.viewModel.moviesObservable.bind { movies in
            self.movies = movies
        }.disposed(by: disposeBag)
    }


}
