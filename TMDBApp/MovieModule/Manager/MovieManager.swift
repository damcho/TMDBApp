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
    var movies:Dictionary<String, [Movie]> = Dictionary()
    
    func fetchMovies(searchParams:SearchObject) {
        if moviesAreInMemory(searchParams: searchParams) {
            self.presenter?.moviesFetchedWithSuccess(movies:self.movies[searchParams.filter.rawValue]! )
        } else if Reachability.isConnectedToNetwork() {
            self.requestMoviesFromAPI(searchParams: searchParams)
        } else {
            self.requestMoviesFromDB(searchParams: searchParams)
        }
    }
    
    func moviesAreInMemory(searchParams:SearchObject) -> Bool {
        return self.movies.index(forKey: searchParams.filter.rawValue) != nil
    }
    
    func requestMoviesFromDB(searchParams: SearchObject) {
        let completionHandler = { (movies:[Movie]?, error:Error?) -> () in
            if error == nil {
                if movies!.count > 0 {
                    self.movies.updateValue(movies!, forKey: searchParams.filter.rawValue)
                }
                self.presenter?.moviesFetchedWithSuccess(movies: movies!)
            } else {
                self.presenter?.moviesFetchFailed(error:error!)
            }
        }
        TMDBCoreDataConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    func requestMoviesFromAPI(searchParams: SearchObject) {
        let completionHandler = { (movies:[Movie]?, error:Error?) -> () in
            if error == nil {
                self.movies.updateValue(movies!, forKey: searchParams.filter.rawValue)
                do {
                    try TMDBCoreDataConnector.shared.storeMovies(movies:self.movies[searchParams.filter.rawValue]!)
                } catch let error {
                    self.presenter?.moviesFetchFailed(error:error)
                }
                self.presenter?.moviesFetchedWithSuccess(movies: self.movies[searchParams.filter.rawValue]!)
            } else {
                self.presenter?.moviesFetchFailed(error:error!)
            }
        }
        TMDBAPIConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    class func getImage(path:String, completion: @escaping (Data) -> ()){
        TMDBAPIConnector.downloadImage(from:path, completion:completion)
    }
}
