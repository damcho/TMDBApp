//
//  MovieDetailViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import YoutubeKit

class MovieDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, YTSwiftyPlayerDelegate, MovieDetailDelegate {

    @IBOutlet weak var movieOverViewTextView: UILabel!
    @IBOutlet weak var videosTableView: UITableView!
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
        self.popularityLabel.text = "\(movie!.popularity)"
        self.voteAverageLabel.text =  "\(movie!.voteAverage)"
        
        movie!.getImage(completion: {[weak self] (imageData:Data?) ->() in
            guard let someImageData = imageData else {
                 self?.movieImageView.image =  UIImage(named: "default")
                return
            }
            self?.movieImageView.image = UIImage(data:someImageData)
        })
        self.movieOverViewTextView.text = movie!.overview
    
    }
    
    func movieDetailFetchedWithError(error:TMDBError){
        self.showAlertView(msg:"There was an error obtaining the videos")
        self.videosTableView.isHidden = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Videos"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movie?.videos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath as IndexPath) as! VideoTableViewCell
        cell.videoTitleLabel.text = movie?.videos![indexPath.row].title
        return cell
    }
    
    func movieDetailFetchedWithSuccess(movie:Movie) {
        self.movie = movie
        self.videosTableView.isHidden = self.movie!.videos?.count == 0
        self.videosTableView.reloadData()
    }
    
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        self.showAlertView(msg:"There was an error loading the video")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let videos = movie?.videos else { return }
        player = YTSwiftyPlayer(
            frame: self.view.bounds,
            playerVars: [.videoID(videos[indexPath.row].id)])
        player.autoplay = true
        player.delegate = self
        player.loadPlayer()
    }

    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        switch state {
        case .paused:
            player.removeFromSuperview()
        case .buffering:
            view.addSubview(player)
        default:
            return
        }
    }


}
