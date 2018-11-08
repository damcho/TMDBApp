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
        
        let completionHandler = { (movies:[Movie]?, error:Error?) -> () in
            if error != nil {
                self.movies = movies!
            }
            completionHandler(error)
        }
        
        if cachedMovies() {
            TMDBCoreDataConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
        } else {
            TMDBAPIConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
        }
    }
    
    private func cachedMovies() -> Bool {
        return false
    }
    
}
