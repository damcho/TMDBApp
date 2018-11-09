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
    
    func getMovies(searchParams:SearchObject, completionHandler: @escaping (Error?) -> ()) {
        
        if cachedMovies() {
            self.requestMoviesFromDB(searchParams: searchParams, completionHandler: completionHandler)
        } else {
          self.requestMoviesFromAPI(searchParams: searchParams, completionHandler: completionHandler)
        }
    }
    
    func requestMoviesFromDB(searchParams: SearchObject, completionHandler: @escaping (Error?) -> ()) {
        let completionHandler = { (movies:[Movie]?, error:Error?) -> () in
            if error == nil {
                self.movies = movies!
            }
            completionHandler(error)
        }
        TMDBCoreDataConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    func requestMoviesFromAPI(searchParams: SearchObject, completionHandler: @escaping (Error?) -> ()) {
        let completionHandler = { (movies:[Movie]?, error:Error?) -> () in
            if error == nil {
                self.movies = movies!
                do {
                    try TMDBCoreDataConnector.shared.storeMovies(movies:self.movies!)
                } catch let error {
                    print("error al grbar \(error.localizedDescription)")
                }
            }
            completionHandler(error)
        }
        TMDBAPIConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    private func cachedMovies() -> Bool {
        return TMDBCoreDataConnector.shared.cachedMovies()
    }
    
}
