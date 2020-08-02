//
//  ViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var movieCategoryFilter: UISegmentedControl!
    @IBOutlet weak var moviesListTableVIew: UITableView!
    
    var interactor: MoviesViewOutput?
    var router: MoviesListRoutes?
    let activityData = ActivityData()
    var activityIndicatorView: NVActivityIndicatorPresenter = NVActivityIndicatorPresenter.sharedInstance
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupRefreshControl()
        movieCategoryFilter.selectedSegmentIndex = 0
        interactor?.viewDidLoad()
    }
}

// Private functions
private extension MoviesListViewController {
    func stopLoadingActivity() {
        activityIndicatorView.stopAnimating(NVActivityIndicatorView.DEFAULT_FADE_OUT_ANIMATION)
        if self.moviesListTableVIew.refreshControl?.isRefreshing ?? false {
            self.moviesListTableVIew.refreshControl?.endRefreshing()
        }
    }
    
    func fetchMovies() {
        self.interactor?.fetchMovies()
    }
    
    func setupRefreshControl() {
        moviesListTableVIew.refreshControl = UIRefreshControl()
        moviesListTableVIew.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    func setupSearchController() {
        let searchController =  UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
        searchController.delegate = self
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
    }
    
    @objc func refreshMovies() {
        movies = []
        moviesListTableVIew.reloadData()
        moviesListTableVIew.refreshControl?.endRefreshing()
        interactor?.reloadMovies()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.navigationItem.searchController!.isActive = false
        self.interactor?.reloadMoviesWith(filterRequest: MoviesFilterRequest(filterCategory: sender.selectedSegmentIndex))
    }
}

extension MoviesListViewController: MoviesListPresenterOutput {
    
    func presentInitialState(screenTitle: String ) {
        self.title = screenTitle
    }
    
    func didRequestMovies() {
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    }
    
    func didReceiveMovies(moviesViewModel: MoviesViewModel) {
        
        self.stopLoadingActivity()
        guard let retrievedMovies = moviesViewModel.movies else { return }
        if retrievedMovies.isEmpty {
            self.showAlertView(msg:"No results")
            self.moviesListTableVIew.isHidden = self.movies.count == 0
            return
        }
        var IndexPathsArray:[IndexPath] = []
        if self.movies.count < retrievedMovies.count {
            for index in self.movies.count..<retrievedMovies.count {
                IndexPathsArray.append(IndexPath(row: index, section: 0))
            }
            self.movies = retrievedMovies
            self.moviesListTableVIew.beginUpdates()
            self.moviesListTableVIew.insertRows(at: IndexPathsArray, with: .none)
            self.moviesListTableVIew.endUpdates()
        } else {
            self.movies = retrievedMovies
            self.moviesListTableVIew.reloadData()
        }
    }
    
    func didRetrieveMoviesWithError(error:TMDBError) {
        self.stopLoadingActivity()
        self.showAlertView(msg:error.localizedDescription)
    }
}

extension MoviesListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row == self.movies.count - 1{
                fetchMovies()
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath as IndexPath) as! MovieTableViewCell
        cell.movie = self.movies[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
}

extension MoviesListViewController: UISearchControllerDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    let movie = self.movies[indexPath.row]
        //    self.interactor?.showMoviesDetail(navController:navigationController!, movie:movie)
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.movieCategoryFilter.selectedSegmentIndex = 0
        self.segmentedControlValueChanged(self.movieCategoryFilter)
    }
}

extension MoviesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        if strippedString.count >= 3 {
            let filterRequest = MoviesFilterRequest(queryString: strippedString)
            self.movieCategoryFilter.selectedSegmentIndex = UISegmentedControl.noSegment
            interactor?.reloadMoviesWith(filterRequest: filterRequest)
        }
    }
}
