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
    func presentInitialState()
    func didRequestMovies()
}

protocol MoviesViewOutput {
    func viewDidLoad()
    func fetchMovies()
    func reloadMovies()
    func reloadMoviesWith(filterRequest: MoviesFilterRequest)
}

protocol MoviesListPresenterOutput: class {
    func didReceiveMovies(moviesViewModel: MoviesViewModel)
    func didRetrieveMoviesWithError(error:TMDBError)
    func presentInitialState(screenTitle: String)
    func didRequestMovies()
}



protocol MovieDetailDelegate: class {
    func movieDetailFetchedWithSuccess(movie: Movie)
    func movieDetailFetchedWithError(error:TMDBError)
}

protocol MoviesListRoutes {
    func pushToMovieDetail(movie:Movie)
}
