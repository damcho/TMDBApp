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
    var movieControllers: [MovieListCellController] = []
    
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
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
    }
    
    @objc func refreshMovies() {
        movieControllers = []
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
    
    func didReceiveMovies(movieCellControllers: [MovieListCellController]) {

        self.stopLoadingActivity()
        if movieCellControllers.isEmpty {
            self.showAlertView(msg:"No results")
            self.moviesListTableVIew.isHidden = self.movieControllers.count == 0
            return
        }
        var IndexPathsArray:[IndexPath] = []

        if self.movieControllers.count < movieCellControllers.count {
            for index in self.movieControllers.count..<movieCellControllers.count {
                IndexPathsArray.append(IndexPath(row: index, section: 0))
            }
            self.movieControllers = movieCellControllers
            self.moviesListTableVIew.beginUpdates()
            self.moviesListTableVIew.insertRows(at: IndexPathsArray, with: .none)
            self.moviesListTableVIew.endUpdates()
        } else {
            self.movieControllers = movieCellControllers
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
            movieControllers[IndexPath.row].preload()
            if IndexPath.row == movieControllers.count - 1{
                fetchMovies()
                return
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            movieControllers[indexPath.row].cancelTask()
        }
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath as IndexPath) as! MovieTableViewCell
        self.movieControllers[indexPath.row].cellView = cellView
        return cellView
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieViewModel = movieControllers[indexPath.row].viewModel else { return }
        router?.pushToMovieDetail(viewModel: movieViewModel)
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
