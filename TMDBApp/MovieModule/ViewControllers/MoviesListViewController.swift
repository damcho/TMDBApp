//
//  ViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MoviesListViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, MovieListDelegate {
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieCategoryFilter: UISegmentedControl!
    @IBOutlet weak var moviesListTableVIew: UITableView!
    var presenter:MoviesPresenter?
    var searchObject:SearchObject = SearchObject()
    let activityData = ActivityData()
    var activityIndicatorView:NVActivityIndicatorPresenter = NVActivityIndicatorPresenter.sharedInstance
    var movies:[Movie] = []
    private var shouldShowLoadingCell = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TMDB"
        self.movieSearchBar.placeholder = "search a movie"
        self.movieCategoryFilter.selectedSegmentIndex = 0
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        self.searchObject.filterValue(value:self.movieCategoryFilter.selectedSegmentIndex)
        self.presenter?.fetchMovies(searchParams:self.searchObject)
        
        moviesListTableVIew.refreshControl = UIRefreshControl()
        moviesListTableVIew.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    func fetchMovies() {
        self.presenter?.fetchMovies(searchParams:self.searchObject)
    }
    
    @objc func refreshMovies() {
        self.movies = []
        self.shouldShowLoadingCell = false
        self.moviesListTableVIew.reloadData()
        self.moviesListTableVIew.refreshControl?.endRefreshing()
        self.searchObject.refreshSearch()
        self.fetchMovies()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.searchObject.filterValue(value: sender.selectedSegmentIndex)
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
        self.refreshMovies()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= self.movies.count {
                fetchMovies()
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.movies[indexPath.row]
        self.presenter?.showMoviesDetail(navController:navigationController!, movie:movie)
    }
    
    func moviesFetchedWithSuccess(movieContainer:MoviesContainer) {
        activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        if self.moviesListTableVIew.refreshControl!.isRefreshing {
            self.moviesListTableVIew.refreshControl?.endRefreshing()
        }
        self.shouldShowLoadingCell = movieContainer.currentPage < movieContainer.totalPages
        self.movies = movieContainer.getMovies()
        self.moviesListTableVIew.isHidden = self.movies.count == 0

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

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        
        self.movieCategoryFilter.selectedSegmentIndex = UISegmentedControl.noSegment

    }
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }


    
}

