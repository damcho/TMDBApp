//
//  MovieDetailViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import YoutubeKit

final class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var movieOverViewTextView: UILabel!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    var movieViewModel: MovieViewModel<UIImage>? 
    var interactor: MovieDetailInteractor?
    private var player: YTSwiftyPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailPresenterOutput {
    
    func movieDetailFetchedWithError(error:TMDBError){
        self.showAlertView(msg:"There was an error obtaining the videos")
        self.videosTableView.isHidden = true
    }
    
    func displayMovieInfo(viewModel: MovieViewModel<UIImage>? = nil) {
        self.movieViewModel = viewModel
        self.title = movieViewModel?.title
        self.movieOverViewTextView.text = movieViewModel?.overview
        self.movieImageView.image = viewModel?.movieThumbImage ?? UIImage(named: "default")
        self.popularityLabel.text = viewModel?.popularoty
        self.voteAverageLabel.text = viewModel?.voteAverage
        self.videosTableView.isHidden = self.movieViewModel?.videos?.count == 0
        self.videosTableView.reloadData()
    }
}

extension MovieDetailViewController: YTSwiftyPlayerDelegate {
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        self.showAlertView(msg:"There was an error loading the video")
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

extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let videos = movieViewModel?.videos else { return }
        player = YTSwiftyPlayer(
            frame: self.view.bounds,
            playerVars: [.videoID(videos[indexPath.row].id)])
        player.autoplay = true
        player.delegate = self
        player.loadPlayer()
    }
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Videos"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath as IndexPath) as! VideoTableViewCell
        cell.videoTitleLabel.text = movieViewModel?.videos![indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieViewModel?.videos?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
}
