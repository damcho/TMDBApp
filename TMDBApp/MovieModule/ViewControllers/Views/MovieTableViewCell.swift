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
    var Movie:Movie?
    
    func setMovie(movie:Movie) {
        self.Movie = movie
        self.movieTitleLabel.text = movie.title
        self.movieImageView.image = nil
        movie.getImage(completion: {(data:Data) ->() in
            self.movieImageView.image = UIImage(data: data)
        })
    }

}
