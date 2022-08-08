//
//  MoviesListCollectionViewCell.swift
//  Challenge
//
//  Created by pedro.pacheco on 08/08/22.
//

import UIKit
import Kingfisher

class MoviesListCollectionViewCell: UICollectionViewCell {

    static let identifier = "MoviesListCollectionViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.posterImageView.image = nil
        self.movieNameLabel.text = nil
    }
    
    func configure(name: String, posterUrl: URL?) {
        self.posterImageView.kf.setImage(with: posterUrl)
        self.movieNameLabel.text = name
    }

}
