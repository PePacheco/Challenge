//
//  MovieDetailsViewController.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit
import SkeletonView
import Combine

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let viewModel: MovieDetailsViewModel
    private var cancellables: [AnyCancellable] = []
    private var movieDetails: MovieDetails? {
        didSet {
            self.updateUI()
        }
    }

    init(viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    deinit {
        self.cancellables = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.posterImageView.showAnimatedGradientSkeleton()
        self.genreLabel.showAnimatedGradientSkeleton()
        self.ratingLabel.showAnimatedGradientSkeleton()
        self.releaseLabel.showAnimatedGradientSkeleton()
        self.descriptionLabel.showAnimatedGradientSkeleton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.fetchMovieDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.posterImageView.isSkeletonable = true
        self.genreLabel.isSkeletonable = true
        self.ratingLabel.isSkeletonable = true
        self.releaseLabel.isSkeletonable = true
        self.descriptionLabel.isSkeletonable = true
        self.bindViewModel()
    }
    
    private func bindViewModel() {
        self.viewModel.errorPublisher.sink {[weak self] error in
            guard let self = self else { return }
            if !error.isEmpty {
                DispatchQueue.main.async {
                    self.presentAlert(message: error, title: "Oops")
                }
            }
        }.store(in: &cancellables)
        
        self.viewModel.moviePublisher.sink {[weak self] movie in
            guard let self = self else { return }
            self.movieDetails = movie
        }.store(in: &cancellables)
    }
    
    private func updateUI() {
        guard let movieDetails = movieDetails else {
            return
        }
        
        self.setUpNavTitle(title: movieDetails.title)
        
        self.posterImageView.kf.setImage(with: URL(string: movieDetails.image))
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.cornerRadius = 4
        
        let fullString = NSMutableAttributedString(string: "")

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "star")
        imageAttachment.image = imageAttachment.image?.withTintColor(UIColor(red: 1.00, green: 1.00, blue: 0.00, alpha: 1.00))

        let startImageString = NSAttributedString(attachment: imageAttachment)

        fullString.append(startImageString)
        fullString.append(NSAttributedString(string: "\(3)"))
        
        DispatchQueue.main.async {
            self.ratingLabel.attributedText = fullString
            self.genreLabel.text = movieDetails.genres.map { $0.name }.joined(separator: ", ")
            self.releaseLabel.text = "Release: \(movieDetails.release_date)"
            self.descriptionLabel.text = movieDetails.overview
        }
        
        self.posterImageView.hideSkeleton()
        self.genreLabel.hideSkeleton()
        self.ratingLabel.hideSkeleton()
        self.releaseLabel.hideSkeleton()
        self.descriptionLabel.hideSkeleton()
    }
    
    private func setUpNavTitle(title: String) {
        let navTitle = UILabel (frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        navTitle.textColor = UIColor.systemBackground
        navTitle.numberOfLines = 0
        navTitle.center = CGPoint(x: 0, y: 0)
        navTitle.textAlignment = .left
        navTitle.text = title
        navTitle.font = .systemFont(ofSize: 16, weight: .bold)

        self.navigationItem.titleView = navTitle
    }

}
