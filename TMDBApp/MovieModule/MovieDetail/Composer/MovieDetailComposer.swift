//
//  MovieDetailComposer.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

final class MovieDetailComposer {
    static func compose(movie: MovieViewModel) -> MovieDetailViewController {
        let movieDetailViewController: MovieDetailViewController = MovieDetailViewController.loadFromStoryboard()
        let movieDetailInteractor = MovieDetailInteractor(
            movieDetailLoader: RemoteMovieDetailLoader(
                client: AlamoFireHttpClient()))
        let movieDetailPresenter = MovieDetailPresenter()
        
        movieDetailPresenter.view = movieDetailViewController
        movieDetailInteractor.presenter = movieDetailPresenter
        movieDetailInteractor.movie = movie.model
        movieDetailViewController.interactor = movieDetailInteractor
        return movieDetailViewController
    }
}
