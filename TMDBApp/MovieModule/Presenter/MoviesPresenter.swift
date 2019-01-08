//
//  MoviesPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

class MoviesPresenter {
    
    var router:MovieModuleRouter?
    var movieManager:MovieManager?
    var moviesListVC:MoviesListViewController?
    var movieDetailVC:MovieDetailViewController?
    
    
    
    func fetchMovies(searchParams:SearchObject) {
        self.movieManager?.fetchMovies(searchParams: searchParams)
    }
    
    func moviesFetchedWithSuccess(movieContainer:MoviesContainer){
        self.moviesListVC!.moviesFetchedWithSuccess(movieContainer:movieContainer)
    }
    
    func moviesFetchFailed(error:Error){
        self.moviesListVC!.moviesFetchWithError(error:error)
    }

    func showMoviesDetail(navController:UINavigationController, movie:Movie) {
        self.router!.pushToMovieDetail(navController:navController, movie:movie)
    }
    
    func filterMovies(searchParams:SearchObject){
        self.movieManager?.fetchMovies(searchParams: searchParams)
    }
    
}
