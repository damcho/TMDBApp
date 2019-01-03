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
    weak var Movie:Movie?
    
    func setMovie(movie:Movie) {
        self.Movie = movie
        self.movieTitleLabel.text = movie.title
        self.movieImageView.image = nil
        self.movieImageView.alpha = 0

        movie.getImage(completion: {[unowned self] (image:UIImage?) ->() in
            self.movieImageView.image = image != nil ? image : UIImage(named: "contactdefault")
            
            UIView.animate(withDuration: 0.25,
                           animations: {
                            self.movieImageView.alpha = 1
            },
                           completion:nil
            )
        })
    }
    
}
