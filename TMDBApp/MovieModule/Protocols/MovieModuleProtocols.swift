//
//  MovieModuleProtocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

typealias moviesContainerCompletionHandler = (MoviesContainer?, Error?) -> ()
typealias movieDetailCompletionHandler = (Movie?, Error?) -> ()


protocol DataConnector {
    
    func getMovies(searchParams: SearchObject, completion: @escaping moviesContainerCompletionHandler )
    func getMovieDetail(searchParams: SearchObject, completion: @escaping movieDetailCompletionHandler) 
    func loadImage(from url: String, completion: @escaping (UIImage?) -> ())

}

protocol MovieListDelegate {
    func moviesFetchedWithSuccess(movieContainer:MoviesContainer)
    func moviesFetchWithError(error:Error)

}

protocol MovieDetailDelegate {
    func movieDetailFetchedWithSuccess(movie:Movie)
    func movieDetailFetchedWithError(error:Error)
}
