//
//  MovieManager.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

class MoviesInteractor {
    var presenter: MoviesInteractorOutput?
    var movies:Dictionary<String, MovieContainer> = Dictionary()
    let apiConnector:MoviesLoader = RemoteMoviesLoader(client: AlamoFireHttpClient())
    static let shared = MoviesInteractor()
    
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
        let completionHandler: MoviesFetchCompletion = {[unowned self] (result) in
            
            switch result {
            case .success(let movieContainer):
                if movieContainer.currentPage == 1 {
                    self.movies[searchParams.category.rawValue] = movieContainer
                } else {
                    self.movies[searchParams.category.rawValue]?.update(page: MovieContainer(currentPage: movieContainer.currentPage, totalPages: movieContainer.totalPages, totalResults: movieContainer.totalResults, movies: movieContainer.movies))
                }
                searchParams.page += 1
                
                self.presenter?.moviesFetchedWithSuccess(movieContainer: self.movies[searchParams.category.rawValue]!)
            case .failure(let error):
                self.presenter?.moviesFetchFailed(error: error)
            }
        }
        
        apiConnector.getMovies(searchParams: searchParams, completion: completionHandler)
    }
    /*
    func requestMovieDetail(searchParams:SearchObject) {
        let completionHandler: MovieDetailFetchCompletion = {[unowned self] (movieDetailResult) in
            switch movieDetailResult {
            case .success(let movie):
                self.presenter?.movieDetailFetchedWithSuccess(movie:movie)
                
            case .failure(let error):
                self.presenter?.movieDetailFetchedWithError(error: error)
            }
        }
        
        apiConnector.getMovieDetail (searchParams: searchParams, completion: completionHandler)
    }
 */
    
    
    func getImage(from path: String, completion: @escaping (Data?) -> ()){
        
     

        let apiDownloadedImageHandler = {(image:Data?) in
            completion(image)
        }
        
        self.apiConnector.loadImage(from: path, completion:apiDownloadedImageHandler)
    }
}

