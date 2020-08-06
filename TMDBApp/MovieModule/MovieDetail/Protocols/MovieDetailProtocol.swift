//
//  MovieDetailProtocol.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

protocol MovieDetailPresenterOutput: class {
    associatedtype Image
    func displayInitialMovieInfo()
    func movieDetailFetchedWithSuccess(movie: MovieViewModel<Image>)
    func movieDetailFetchedWithError(error: TMDBError)
}

protocol MovieDetailInteractorOutput: class {
    func presentInitialMovieInfo()
    func presentFullMovieDetail(movie: Movie)
}

protocol MovieDetailViewOutput {
    func viewDidLoad()
}
