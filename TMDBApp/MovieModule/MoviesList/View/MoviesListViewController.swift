//
//  ViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var movieCategoryFilter: UISegmentedControl!
    @IBOutlet weak var moviesListTableVIew: UITableView!
    @IBOutlet weak var NoResultsView: UIView!
    
    var interactor: (MoviesViewOutput & MoviesFilter)?
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
        moviesListTableVIew.refreshControl?.endRefreshing()
    }
    
    func setupRefreshControl() {
        moviesListTableVIew.refreshControl = UIRefreshControl()
        moviesListTableVIew.refreshControl?.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }
    
    func setupSearchController() {
        navigationItem.searchController = MoviesListSearchController(interactor: self.interactor!)
        definesPresentationContext = true
    }
    
    @objc func refreshMovies() {
        moviesListTableVIew.refreshControl?.beginRefreshing()
        movieControllers = []
        interactor?.reloadMovies()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        interactor?.filterMoviesWith(filterRequest: MoviesFilterRequest(filterCategory: sender.selectedSegmentIndex))
    }
    
    func loadNewMovieCells(cellControllers: [MovieListCellController]) {
        movieControllers = cellControllers
        moviesListTableVIew.reloadData()
        moviesListTableVIew.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    func addNewCellsToCurrentList(cellControllers: [MovieListCellController]) {
        var indexpaths: [IndexPath] = []
        let startIndex = movieControllers.count
        let endIndex = cellControllers.count
        for index in startIndex ..< endIndex {
            indexpaths.append(IndexPath(item: index, section: 0))
        }
        moviesListTableVIew.performBatchUpdates({
            movieControllers = cellControllers
            moviesListTableVIew.insertRows(at: indexpaths, with: .none)
        }, completion: nil)
    }
}

extension MoviesListViewController: MoviesListPresenterOutput {
    
    func presentInitialState(screenTitle: String ) {
        title = screenTitle
    }
    
    func didRequestMovies() {
        activityIndicatorView.startAnimating(activityData, NVActivityIndicatorView.DEFAULT_FADE_IN_ANIMATION)
    }
    
    func didReceiveEmptyMovieResults() {
        stopLoadingActivity()
        moviesListTableVIew.isHidden = true
    }
    
    func didReceiveMovies(movieCellControllers: [MovieListCellController]) {
        stopLoadingActivity()
        moviesListTableVIew.isHidden = false
        if !movieControllers.isEmpty,
            movieCellControllers.count > movieControllers.count{
            addNewCellsToCurrentList(cellControllers: movieCellControllers)
        } else {
            loadNewMovieCells(cellControllers: movieCellControllers)
        }
    }
    
    func didReceiveError(error: ErrorViewModel) {
        stopLoadingActivity()
        showAlertView(msg:error.errorDescription)
    }
}

extension MoviesListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach({ (IndexPath) in
            movieControllers[IndexPath.row].preload()
            if IndexPath.row == movieControllers.count - 1{
                interactor?.fetchMovies()
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
        return movieControllers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cellView = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath as IndexPath) as! MovieTableViewCell
        movieControllers[indexPath.row].cellView = cellView
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row < movieControllers.count {
            movieControllers[indexPath.row].cancelTask()
        }
    }
}
