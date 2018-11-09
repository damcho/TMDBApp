//
//  MoviesPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class MoviesPresenter {
    
    var router:MovieModuleRouter?
    var movieManager:MovieManager?
    var moviesListVC:MoviesListViewController?
    var movieDetailVC:MovieDetailViewController?
    
    
    
    func fetchMovies(searchParams:SearchObject) {
        self.movieManager?.fetchMovies(searchParams: searchParams)
    }
    
    func moviesFetchedWithSuccess(movies:[Movie]){
        self.moviesListVC!.moviesFetchedWithSuccess()
    }
    
    func moviesFetchFailed(error:Error){
        self.moviesListVC!.moviesFetchWithError(error:error)
    }
    
    func getMoviesCount() -> Int {
        return self.movieManager!.getMoviesCount()
    }
    
    func getMovieAtIndex(indexPath:Int) -> Movie? {
        return self.movieManager!.getMovieAtIndex(indexPath:indexPath)
    }

    
}
