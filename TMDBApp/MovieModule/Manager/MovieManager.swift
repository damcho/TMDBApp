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
    var movies:Dictionary<String, MoviePage> = Dictionary()
    let apiConnector:DataConnector = TMDBAPIConnector.shared
    let dbConnector:DataConnector = TMDBCoreDataConnector.shared

    let imageCache = NSCache<NSString, UIImage>()
    static let shared = MovieManager()
    
    func fetchMovies(searchParams:SearchObject) {
        if Reachability.isConnectedToNetwork() {
            self.requestMoviesFromAPI(searchParams: searchParams)
        } else {
            self.requestMoviesFromDB(searchParams: searchParams)
        }
    }
    
    func moviesAreInMemory(searchParams:SearchObject) -> Bool {
        return self.movies.index(forKey: searchParams.filter.rawValue) != nil
    }
    
    func requestMoviesFromDB(searchParams: SearchObject) {
        let completionHandler = { [unowned self] (moviePage:MoviePage?, error:Error?) -> () in
            if error == nil {
                if moviePage!.movies.count > 0 {
                    self.movies.updateValue(moviePage!, forKey: searchParams.filter.rawValue)
                }
                self.presenter?.moviesFetchedWithSuccess(moviePage: moviePage!)
            } else {
                self.presenter?.moviesFetchFailed(error:error!)
            }
        }
        TMDBCoreDataConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    func requestMoviesFromAPI(searchParams: SearchObject) {
        let completionHandler = {[unowned self] (moviePage:MoviePage?, error:Error?) -> () in
            if error == nil {
                self.movies[searchParams.filter.rawValue] = moviePage!
                
                do {
                    try TMDBCoreDataConnector.shared.storeMovies(movies:self.movies[searchParams.filter.rawValue]!.movies)
                } catch let error {
                    self.presenter?.moviesFetchFailed(error:error)
                }
                self.presenter?.moviesFetchedWithSuccess(moviePage: self.movies[searchParams.filter.rawValue]!)
            } else {
                self.presenter?.moviesFetchFailed(error:error!)
            }
        }
        TMDBAPIConnector.shared.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    
    
    func getImage(path:String, completion: @escaping (UIImage?) -> ()){
        
        if let cachedImage = imageCache.object(forKey: path as NSString) {
            completion(cachedImage)
            return
        }
        
        let apiDownloadedImageHandler = {[unowned self] (image:UIImage?) in
            if image != nil {
                self.imageCache.setObject(image!, forKey: path as NSString)
                self.dbConnector.saveImage(imageData: image!.pngData()!, with: path, and: nil)
            }
            completion(image)
        }
        
        let dbDownloadedImageHandler = { [unowned self] (image:UIImage?) in
            if image != nil {
                self.imageCache.setObject(image!, forKey: path as NSString)
            }
            completion(image)
        }
        
        if Reachability.isConnectedToNetwork() {
            self.apiConnector.loadImage(from:path, completion:apiDownloadedImageHandler)
        } else {
            self.dbConnector.loadImage(from: path, completion:dbDownloadedImageHandler)            
        }
    }
}
