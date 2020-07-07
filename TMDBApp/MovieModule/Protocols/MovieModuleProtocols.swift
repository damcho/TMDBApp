//
//  MovieModuleProtocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

typealias MoviesFetchCompletion = (IMDBResult) -> ()
typealias MovieDetailFetchCompletion = (MovieDetailResult) -> ()


protocol DataConnector {
    func getMovies(searchParams: SearchObject, completion:  @escaping (IMDBResult) -> ())
    func getMovieDetail(searchParams: SearchObject, completion:  @escaping (MovieDetailResult) -> ())
    func loadImage(from imagePath: String, completion:  @escaping (Data?) -> ())
}

protocol MovieListDelegate {
    func moviesFetchedWithSuccess(movieContainer: MovieContainer)
    func moviesFetchWithError(error:TMDBError)

}

protocol MovieDetailDelegate {
    func movieDetailFetchedWithSuccess(movie: Movie)
    func movieDetailFetchedWithError(error:TMDBError)
}
