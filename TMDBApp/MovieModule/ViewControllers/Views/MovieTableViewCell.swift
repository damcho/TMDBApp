//
//  MovieTableViewCell.swift
//  TMDBApp
//
//  Created by Damian Modernell on 09/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var movie: Movie? {
        didSet {
            self.setMovie()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = UIImage(named: "default")
        movieTitleLabel.text = nil
    }
    
    func setMovie() {
        self.movieTitleLabel.text = movie?.title
        self.movieImageView.alpha = 0
    }
}
