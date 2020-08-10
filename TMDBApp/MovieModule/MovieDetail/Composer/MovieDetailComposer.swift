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
        let httpClient = AlamoFireHttpClient()
        
        let movieDetailInteractor = MovieDetailInteractor(
            movieDetailLoader: RemoteMovieDetailLoader(
                client: httpClient ),
            imageLoader: ImageDataLoader(client: httpClient))
        
        let movieDetailPresenter = MovieDetailPresenter(view: WeakyFyedInstance( movieDetailViewController), imageTransformer: UIImage.init)
        
        movieDetailInteractor.presenter = movieDetailPresenter
        movieDetailInteractor.movie = Movie(title: viewModel.title, movieID: viewModel.movieID, overview: viewModel.overview)
        movieDetailViewController.interactor = movieDetailInteractor
        return movieDetailViewController
    }
}
