//
//  MovieDetailViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    var movie:Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.movie!.title
        movie!.getImage(completion: {[weak self] (image:UIImage?) ->() in
            self?.movieImageView.image = image != nil ? image : UIImage(named: "contactdefault")
        })
        self.movieOverviewLabel.text = movie!.overview
        self.popularityLabel.text = String(movie!.popularity)
        self.voteAverageLabel.text = String(movie!.voteAverage)
    }

}
