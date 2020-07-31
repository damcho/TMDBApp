//
//  MovieModuleProtocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

protocol MoviesInteractorOutput {
    func moviesFetchedWithSuccess(movieContainer:MovieContainer)
    func moviesFetchFailed(error:TMDBError)
}

protocol MoviesViewOutput {
    func viewDidLoad()
    func fetchMovies(searchParams: SearchObject)
}

protocol MovieListDelegate {
    func moviesFetchedWithSuccess(movieContainer: MovieContainer)
    func moviesFetchWithError(error:TMDBError)
}

protocol MovieDetailDelegate {
    func movieDetailFetchedWithSuccess(movie: Movie)
    func movieDetailFetchedWithError(error:TMDBError)
}
