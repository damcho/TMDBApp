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
    static func compose(viewModel: MovieViewModel<UIImage>) -> MovieDetailViewController {
        let movieDetailViewController: MovieDetailViewController = MovieDetailViewController.loadFromStoryboard()
        movieDetailViewController.movieViewModel = viewModel
        let movieDetailInteractor = MovieDetailInteractor(
            movieDetailLoader: RemoteMovieDetailLoader(
                client: AlamoFireHttpClient()))
        let movieDetailPresenter = MovieDetailPresenter<MovieDetailViewController, UIImage>()
        
        movieDetailPresenter.view = movieDetailViewController
        movieDetailInteractor.presenter = movieDetailPresenter
        
        movieDetailViewController.interactor = movieDetailInteractor
        return movieDetailViewController
    }
}
