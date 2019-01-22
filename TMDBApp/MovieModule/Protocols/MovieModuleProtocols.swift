//
//  MovieModuleProtocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

typealias moviesContainerCompletionHandler = (MoviesContainer?, TMDBError?) -> ()
typealias movieDetailCompletionHandler = (Movie?, TMDBError?) -> ()


protocol DataConnector {
    
    func getMovies(searchParams: SearchObject, completion: @escaping moviesContainerCompletionHandler )
    func getMovieDetail(searchParams: SearchObject, completion: @escaping movieDetailCompletionHandler) 
    func loadImage(from url: String, completion: @escaping (UIImage?) -> ())

}

protocol MovieListDelegate {
    func moviesFetchedWithSuccess(movieContainer:MoviesContainer)
    func moviesFetchWithError(error:TMDBError)

}

protocol MovieDetailDelegate {
    func movieDetailFetchedWithSuccess(movie:Movie)
    func movieDetailFetchedWithError(error:TMDBError)
}
