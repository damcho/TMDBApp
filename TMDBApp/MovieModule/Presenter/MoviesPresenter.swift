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
    
    var router:MoviesListRouter?
    var movieManager:MoviesInteractor?
    var moviesListVC:MovieListDelegate?
    var movieDetailVC:MovieDetailDelegate?
    
    
    
    func fetchMovies(searchParams:SearchObject) {
        self.movieManager?.fetchMovies(searchParams: searchParams)
    }
    
    func getMovieDetail(searchParams:SearchObject) {
     //   self.movieManager?.requestMovieDetail(searchParams: searchParams)
    }

    func showMoviesDetail(movie:Movie) {
        self.router?.pushToMovieDetail(movie:movie)
    }
    
    func filterMovies(searchParams:SearchObject){
        self.movieManager?.fetchMovies(searchParams: searchParams)
    }
    
    func movieDetailFetchedWithSuccess(movie: Movie) {
        self.movieDetailVC?.movieDetailFetchedWithSuccess(movie:movie)
    }
    
    func movieDetailFetchedWithError(error:TMDBError) {
        self.movieDetailVC?.movieDetailFetchedWithError(error:error)

    }
    
}

extension MoviesPresenter: MoviesInteractorOutput {
    func moviesFetchedWithSuccess(movieContainer:MovieContainer){
          self.moviesListVC!.moviesFetchedWithSuccess(movieContainer:movieContainer)
      }
      
      func moviesFetchFailed(error:TMDBError){
          self.moviesListVC!.moviesFetchWithError(error:error)
      }
}
