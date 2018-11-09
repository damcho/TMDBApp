//
//  MovieManager.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class MovieManager {
    var presenter:MoviesPresenter?
    var movies:[Movie]?
    
    func getMoviesCount() -> Int {
        guard let moviesCOunt = self.movies?.count else {
            return 0
        }
        return moviesCOunt
    }
    
    func getMovieAtIndex(indexPath:Int) -> Movie? {
        return self.movies![indexPath]
    }
    
    func fetchMovies(searchParams:SearchObject) {
        
        if cachedMovies() {
            self.requestMoviesFromDB(searchParams: searchParams)
        } else {
          self.requestMoviesFromAPI(searchParams: searchParams)
        }
    }
    
    func requestMoviesFromDB(searchParams: SearchObject) {
        let completionHandler = { (movies:[Movie]?, error:Error?) -> () in
            if error == nil {
                self.movies = movies!
                self.presenter?.moviesFetchedWithSuccess(movies: self.movies!)
            } else {
                self.presenter?.moviesFetchFailed(error:error!)
            }
        }
        TMDBCoreDataConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    func requestMoviesFromAPI(searchParams: SearchObject) {
        let completionHandler = { (movies:[Movie]?, error:Error?) -> () in
            if error == nil {
                self.movies = movies!
                do {
                    try TMDBCoreDataConnector.shared.storeMovies(movies:self.movies!)
                } catch let error {
                    print("error al grbar \(error.localizedDescription)")
                    self.presenter?.moviesFetchFailed(error:error)
                }
                self.presenter?.moviesFetchedWithSuccess(movies: self.movies!)
            } else {
                self.presenter?.moviesFetchFailed(error:error!)
            }
        }
        TMDBAPIConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    private func cachedMovies() -> Bool {
        return TMDBCoreDataConnector.shared.cachedMovies()
    }
    
}
