//
//  MovieManager.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

class MovieManager {
    var presenter:MoviesPresenter?
    var movies:Dictionary<String, MoviesContainer> = Dictionary()
    let apiConnector:DataConnector = TMDBAPIConnector.shared
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = MovieManager()
    
    func fetchMovies(searchParams:SearchObject) {
        if Reachability.isConnectedToNetwork() {
            self.requestMoviesFromAPI(searchParams: searchParams)
        } else if moviesAreInMemory(searchParams: searchParams){
            self.presenter?.moviesFetchedWithSuccess(movieContainer: self.movies[searchParams.category.rawValue]!)
        } else {
            self.presenter?.moviesFetchFailed(error:TMDBError.NOT_FOUND)
        }
    }
    
    func moviesAreInMemory(searchParams:SearchObject) -> Bool {
        return self.movies.index(forKey: searchParams.category.rawValue) != nil
    }
    
    
    func requestMoviesFromAPI(searchParams: SearchObject) {
        let completionHandler = {[unowned self] (movieContainer:MoviesContainer?, error:TMDBError?) -> () in
            
            guard let movieContainer = movieContainer else {
                switch error! {
                case .API_ERROR, .MALFORMED_DATA:
                    self.presenter?.moviesFetchFailed(error:error!)
                    return
                default:
                    return
                }
            }
            
            if movieContainer.currentPage == 1 {
                self.movies[searchParams.category.rawValue] = movieContainer
            } else {
                self.movies[searchParams.category.rawValue]?.update(page: movieContainer)
            }
            searchParams.page += 1
            
            self.presenter?.moviesFetchedWithSuccess(movieContainer: self.movies[searchParams.category.rawValue]!)
        }
        
        apiConnector.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    func requestMovieDetail(searchParams:SearchObject) {
        let completionHandler = {[unowned self] (movie:Movie?, error:TMDBError?) -> () in
            guard let movie = movie else {
                self.presenter?.movieDetailFetchedWithError(error: error!)
                return
            }
            self.presenter?.movieDetailFetchedWithSuccess(movie:movie)
        }
        
        apiConnector.getMovieDetail (searchParams: searchParams, completion: completionHandler)
    }
    
    
    func getImage(path:String, completion: @escaping (UIImage?) -> ()){
        
        if let cachedImage = imageCache.object(forKey: path as NSString) {
            completion(cachedImage)
            return
        }
        
        let apiDownloadedImageHandler = {[unowned self] (image:UIImage?) in
            if image != nil {
                self.imageCache.setObject(image!, forKey: path as NSString)
            }
            completion(image)
        }
        
        self.apiConnector.loadImage(from:path, completion:apiDownloadedImageHandler)
    }
}
