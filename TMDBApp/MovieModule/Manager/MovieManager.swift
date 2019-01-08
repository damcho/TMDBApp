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
            self.presenter?.moviesFetchFailed(error: NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Resource not found"]))
        }
    }
    
    func moviesAreInMemory(searchParams:SearchObject) -> Bool {
        return self.movies.index(forKey: searchParams.category.rawValue) != nil &&
        searchParams.page <=  self.movies[searchParams.category.rawValue]!.currentPage
    }
   
    
    func requestMoviesFromAPI(searchParams: SearchObject) {
        let completionHandler = {[unowned self] (movieContainer:MoviesContainer?, error:Error?) -> () in
            if error == nil {
                if  movieContainer!.currentPage == 1 {
                    self.movies[searchParams.category.rawValue] = movieContainer
                } else {
                    self.movies[searchParams.category.rawValue]?.update(page: movieContainer!)
                }

                self.presenter?.moviesFetchedWithSuccess(movieContainer: self.movies[searchParams.category.rawValue]!)
            } else {
                self.presenter?.moviesFetchFailed(error:error!)
            }
        }
        apiConnector.getMovies(searchParams: searchParams, completion: completionHandler)
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
        
        if Reachability.isConnectedToNetwork() {
            self.apiConnector.loadImage(from:path, completion:apiDownloadedImageHandler)
        } else {
            completion(nil)
        }
    }
}
