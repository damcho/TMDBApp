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
    var movieViewModels: [MovieViewModel] = []
    
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
        movieViewModels = []
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
    
    func didReceiveMovies(moviesViewModel: MoviesListViewModel) {
        
        self.stopLoadingActivity()
        guard let retrievedMovies = moviesViewModel.movies else { return }
        if retrievedMovies.isEmpty {
            self.showAlertView(msg:"No results")
            self.moviesListTableVIew.isHidden = self.movieViewModels.count == 0
            return
        }
        var IndexPathsArray:[IndexPath] = []
        if self.movieViewModels.count < retrievedMovies.count {
            for index in self.movieViewModels.count..<retrievedMovies.count {
                IndexPathsArray.append(IndexPath(row: index, section: 0))
            }
            self.movieViewModels = retrievedMovies
            self.moviesListTableVIew.beginUpdates()
            self.moviesListTableVIew.insertRows(at: IndexPathsArray, with: .none)
            self.moviesListTableVIew.endUpdates()
        } else {
            self.movieViewModels = retrievedMovies
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
        indexPaths.forEach({ (IndexPath) in
            movieViewModels[IndexPath.row].preload()
            if IndexPath.row == movieViewModels.count - 1{
                fetchMovies()
                return
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            movieViewModels[indexPath.row].cancelTask()
        }
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath as IndexPath) as! MovieTableViewCell
        self.movieViewModels[indexPath.row].view = cellView
        return cellView
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
