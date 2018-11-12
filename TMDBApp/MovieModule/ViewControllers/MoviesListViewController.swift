//
//  ViewController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class MoviesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieCategoryFilter: UISegmentedControl!
    @IBOutlet weak var moviesListTableVIew: UITableView!
    var presenter:MoviesPresenter?
    var searchObject:SearchObject?
    var movies:[Movie]?
    var activityIndicatorView:NVActivityIndicatorPresenter?


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TMDB list"
        self.searchObject = SearchObject()
        self.movieCategoryFilter.selectedSegmentIndex = 0
        activityIndicatorView = NVActivityIndicatorPresenter.sharedInstance
        let activityData = ActivityData()
        activityIndicatorView?.startAnimating(activityData, nil)
        self.searchObject!.filterValue(value:self.movieCategoryFilter.selectedSegmentIndex)
        self.presenter?.fetchMovies(searchParams:self.searchObject!)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let activityData = ActivityData()
        self.searchObject!.filterValue(value: sender.selectedSegmentIndex)
        activityIndicatorView?.startAnimating(activityData, nil)
        self.presenter!.filterMovies(searchParams:self.searchObject!)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let moviesCount = self.movies?.count else {
            return 0
        }
        return moviesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath as IndexPath) as! MovieTableViewCell
        
        cell.setMovie(movie: self.movies![indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = self.movies![indexPath.row]
        self.presenter?.showMoviesDetail(navController:navigationController!, movie:movie)
    }
    
    func moviesFetchedWithSuccess(movies:[Movie]) {
        activityIndicatorView?.stopAnimating(nil)

        if movies.count > 0 {
            self.movies = movies
            self.moviesListTableVIew.reloadData()
        } else {
            self.showAlertView(msg:"No results")
        }
    }

    func moviesFetchWithError(error:Error) {
        activityIndicatorView?.stopAnimating(nil)
        self.showAlertView(msg:error.localizedDescription)
    }
    
    func showAlertView(msg:String) -> () {
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

