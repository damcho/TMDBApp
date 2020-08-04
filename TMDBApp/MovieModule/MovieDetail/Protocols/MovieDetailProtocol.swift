//
//  MovieDetailProtocol.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

protocol MovieDetailPresenterOutput: class {
    func displayInitialMovieInfo(viewModel: MovieViewModel)
    func movieDetailFetchedWithSuccess(movie: MovieViewModel)
    func movieDetailFetchedWithError(error: TMDBError)
}

protocol MovieDetailInteractorOutput {
    func presentInitialMovieInfo(movie: Movie)
    func presentFullMovieDetail(movie: Movie)
}

protocol MovieDetailViewOutput {
    
}
