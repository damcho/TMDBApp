//
//  MovieDetailPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class MovieDetailPresenter {
    weak var view: MovieDetailPresenterOutput?
}

extension MovieDetailPresenter: MovieDetailInteractorOutput {
    func presentFullMovieDetail(movie: Movie) {
        let viewModel = MovieViewModel(model: movie)
        view?.movieDetailFetchedWithSuccess(movie: viewModel)
    }
    
    func presentInitialMovieInfo(movie: Movie) {
        let viewModel = MovieViewModel(model: movie)
        view?.displayInitialMovieInfo(viewModel: viewModel)
    }
}
