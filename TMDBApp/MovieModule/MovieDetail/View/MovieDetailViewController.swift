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
    
    var movie: MovieViewModel?
    var interactor: MovieDetailInteractor?
    private var player: YTSwiftyPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

extension MovieDetailViewController: MovieDetailPresenterOutput {
    func displayInitialMovieInfo(viewModel: MovieViewModel) {
        self.movieOverViewTextView.text = viewModel.model.overview
        self.title = viewModel.model.title
    }
    
    func movieDetailFetchedWithError(error:TMDBError){
        self.showAlertView(msg:"There was an error obtaining the videos")
        self.videosTableView.isHidden = true
    }
    
    func movieDetailFetchedWithSuccess(movie: MovieViewModel) {
        self.movie = movie
        self.videosTableView.isHidden = self.movie!.model.videos?.count == 0
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
        guard let videos = movie?.model.videos else { return }
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
        cell.videoTitleLabel.text = movie?.model.videos![indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movie?.model.videos?.count ?? 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
}
