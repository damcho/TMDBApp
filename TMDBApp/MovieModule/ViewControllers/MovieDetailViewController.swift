//
//  MovieDetailViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import YoutubeKit

class MovieDetailViewController: UIViewController,YTSwiftyPlayerDelegate, MovieDetailDelegate {

    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    var movie:Movie?
    var presenter:MoviesPresenter?
    private var player: YTSwiftyPlayer!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchObj = SearchObject()
        searchObj.movie = movie
        self.presenter?.getMovieDetail(searchParams: searchObj)
        
        self.title = self.movie!.title
        movie!.getImage(completion: {[weak self] (image:UIImage?) ->() in
            self?.movieImageView.image = image != nil ? image : UIImage(named: "default")
        })
        self.movieOverviewLabel.text = movie!.overview
        self.popularityLabel.text = String(movie!.popularity)
        self.voteAverageLabel.text = String(movie!.voteAverage)
    }
    
    func movieDetailFetchedWithError(error:Error){
        
    }
    
    func movieDetailFetchedWithSuccess(movie:Movie) {
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 0, width: 640, height: 480),
            playerVars: [.videoID("V4XWq_sRDw")])
        print( movie.videos![0].id)
        // Enable auto playback when video is loaded
        player.autoplay = true
        
        // Set player view.
        view.addSubview(player)
        
        // Set delegate for detect callback information from the player.
        player.delegate = self
        
        // Load the video.
        player.loadPlayer()
    }
    
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        
        
    }


}
