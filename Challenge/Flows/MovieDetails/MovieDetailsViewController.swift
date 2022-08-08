//
//  MovieDetailsViewController.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit
import RxSwift
import RxCocoa
import SkeletonView

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private let viewModel: MovieDetailsViewModel
    private let disposeBag: DisposeBag
    private var movieDetails: MovieDetails? {
        didSet {
            self.updateUI()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.posterImageView.isSkeletonable = true
        self.genreLabel.isSkeletonable = true
        self.ratingLabel.isSkeletonable = true
        self.releaseLabel.isSkeletonable = true
        self.descriptionLabel.isSkeletonable = true
        
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
        self.bindViewModel()
    }
    
    private func bindViewModel() {
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
        guard let movieDetails = movieDetails else {
            return
        }
        
        self.title = movieDetails.title
        self.posterImageView.kf.setImage(with: URL(string: movieDetails.image))
        self.posterImageView.layer.cornerRadius = 4
        
        let fullString = NSMutableAttributedString(string: "")

        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(systemName: "star")

        let image1String = NSAttributedString(attachment: image1Attachment)

        fullString.append(image1String)
        fullString.append(NSAttributedString(string: movieDetails.rating))
        
        self.ratingLabel.attributedText = fullString
        self.genreLabel.text = movieDetails.genres.map { $0.name }.joined(separator: ", ")
        self.releaseLabel.text = "Estréia: \(movieDetails.release)"
        self.descriptionLabel.text = movieDetails.description
        
        self.posterImageView.hideSkeleton()
        self.genreLabel.hideSkeleton()
        self.ratingLabel.hideSkeleton()
        self.releaseLabel.hideSkeleton()
        self.descriptionLabel.hideSkeleton()
    }

}
