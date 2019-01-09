//
//  ViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MoviesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieListDelegate {
    
    @IBOutlet weak var movieCategoryFilter: UISegmentedControl!
    @IBOutlet weak var moviesListTableVIew: UITableView!
    var presenter:MoviesPresenter?
    var searchObject:SearchObject = SearchObject()
    let activityData = ActivityData()
    var movies:[Movie] = []
    var currentPage = 1
    private var shouldShowLoadingCell = false
    var activityIndicatorView:NVActivityIndicatorPresenter = NVActivityIndicatorPresenter.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TMDB"
        self.movieCategoryFilter.selectedSegmentIndex = 0
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        self.searchObject.filterValue(value:self.movieCategoryFilter.selectedSegmentIndex)
        self.presenter?.fetchMovies(searchParams:self.searchObject)
        
        moviesListTableVIew.refreshControl = UIRefreshControl()
        moviesListTableVIew.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    func fetchMovies() {
        self.searchObject.page += 1
        self.presenter?.fetchMovies(searchParams:self.searchObject)
    }
    
    @objc func refreshMovies() {
        self.searchObject.page = 1
        self.presenter?.fetchMovies(searchParams:self.searchObject)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.searchObject.filterValue(value: sender.selectedSegmentIndex)
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.shouldShowLoadingCell = false
        self.moviesListTableVIew.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
        self.refreshMovies()
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowLoadingCell ? self.movies.count + 1 : self.movies.count
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard shouldShowLoadingCell else { return false }
        return indexPath.row == self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        if isLoadingIndexPath(indexPath) {
            return tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath as IndexPath)
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath as IndexPath) as! MovieTableViewCell
            cell.tag = indexPath.row
            cell.setMovie(movie: self.movies[indexPath.row],mewIndexPath:indexPath, imageCompletion: { (image:UIImage, mewIndexPath:IndexPath) -> () in
                if cell.tag == indexPath.row {
                    cell.movieImageView.image = image
                }
            } )
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoadingIndexPath(indexPath) else { return }
        fetchMovies()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.presenter?.showMoviesDetail(navController:navigationController!, movie:movie)
    }
    
    func moviesFetchedWithSuccess(movieContainer:MoviesContainer) {
        print("moviesFetched")
        activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        self.moviesListTableVIew.refreshControl?.endRefreshing()
        self.shouldShowLoadingCell = movieContainer.currentPage < movieContainer.totalPages
        self.movies = movieContainer.currentPage == 1 ? [] : self.movies
        self.movies = movieContainer.getMovies()
        
        if self.movies.count > 0 {
            self.moviesListTableVIew.reloadData()
        } else {
            self.showAlertView(msg:"No results")
        }
    }
    
    func moviesFetchWithError(error:Error) {
        activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        self.showAlertView(msg:error.localizedDescription)
    }
    
    func showAlertView(msg:String) -> () {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

