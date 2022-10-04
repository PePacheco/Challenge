//
//  MoviesListViewController.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit
import Combine
import RxSwift

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let viewModel: MoviesListViewModel
    private var cancellables: [AnyCancellable] = []
    private var movies: [Movie] = [] {
        didSet {
            self.moviesCollectionView.reloadData()
        }
    }
        
    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    deinit {
        self.cancellables = []
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
        self.view.backgroundColor = .label
        self.setUpNavigationBar()
        self.bindViewModel()
        self.setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        self.moviesCollectionView.register(UINib(nibName: MoviesListCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MoviesListCollectionViewCell.identifier)
        self.moviesCollectionView.dataSource = self
        self.moviesCollectionView.delegate = self
    }
    
    private func setUpNavigationBar() {
        let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        lbNavTitle.textColor = UIColor.systemBackground
        lbNavTitle.numberOfLines = 0
        lbNavTitle.center = CGPoint(x: 0, y: 0)
        lbNavTitle.textAlignment = .left
        lbNavTitle.text = "Cine SKY"
        lbNavTitle.font = .systemFont(ofSize: 20, weight: .bold)

        self.navigationItem.titleView = lbNavTitle
    }
    
    private func bindViewModel() {
        self.viewModel.isLoadingPublisher.sink {[weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.presentLoadingScreen()
            } else {
                self.dismiss(animated: true)
            }
        }.store(in: &cancellables)
        
        self.viewModel.errorPublisher.sink {[weak self] error in
            guard let self = self else { return }
            if !error.isEmpty {
                self.presentAlert(message: error, title: "Oops")
            }
        }.store(in: &cancellables)
        
        self.viewModel.moviesPublisher.sink {[weak self] movies in
            guard let self = self else { return }
            self.movies = movies
        }.store(in: &cancellables)
    }


}

extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesListCollectionViewCell.identifier, for: indexPath) as?  MoviesListCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = self.viewModel.getMovie(at: indexPath)
        let url = URL(string: movie.image)
        cell.configure(name: movie.title, posterUrl: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.showDetails(at: indexPath)
    }
    
}

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = (screenSize.width - 48)/2
        return CGSize(width: cellWidth, height: cellWidth * 1.42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0)
    }
    
}
