//
//  MovieModuleProtocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

protocol MoviesInteractorOutput {
    func moviesFetchedWithSuccess(movies: [Movie])
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
    func didReceiveMovies(movieCellControllers: [MovieListCellController])
    func didReceiveEmptyMovieReslts()
    func didRetrieveMoviesWithError(error: ErrorViewModel)
    func presentInitialState(screenTitle: String)
    func didRequestMovies()
}


