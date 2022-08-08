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
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    private let viewModel: MoviesListViewModel
    private let disposeBag: DisposeBag
    private var movies: [Movie] = [] {
        didSet {
            self.moviesCollectionView.reloadData()
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
        lbNavTitle.textColor = UIColor.white
        lbNavTitle.numberOfLines = 0
        lbNavTitle.center = CGPoint(x: 0, y: 0)
        lbNavTitle.textAlignment = .left
        lbNavTitle.text = "Cine SKY"
        lbNavTitle.font = .systemFont(ofSize: 20, weight: .bold)

        self.navigationItem.titleView = lbNavTitle
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
            DispatchQueue.main.async {
                self.movies = movies
            }
        }.disposed(by: disposeBag)
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
    
}

extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = (screenSize.width - 48)/2
        return CGSize(width: cellWidth, height: cellWidth * 1.35)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0)
    }
    
}
