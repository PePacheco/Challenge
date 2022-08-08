//
//  MovieDetailsViewController.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailsViewController: UIViewController {
    
    private let viewModel: MovieDetailsViewModel
    private let disposeBag: DisposeBag
    private var movieDetails: MovieDetails? {
        didSet {
            self.updateUI()
            print(movieDetails)
        }
    }

    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchMovieDetails()
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
        
        self.viewModel.movieObservable.bind { movie in
            if let movie = movie {
                DispatchQueue.main.async {
                    self.movieDetails = movie
                }
            }
        }.disposed(by: disposeBag)
    }
    
    private func updateUI() {
        
    }

}
