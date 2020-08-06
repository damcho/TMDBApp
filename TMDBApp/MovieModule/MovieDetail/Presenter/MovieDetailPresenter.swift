//
//  MovieDetailPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit
final class MovieDetailPresenter<PresenterOutput: MovieDetailPresenterOutput, Image> where PresenterOutput.Image == Image {
    weak var view: PresenterOutput?
    var imageTransformer: ((Data) -> Image)?
}

extension MovieDetailPresenter: MovieDetailInteractorOutput {
    func presentFullMovieDetail(movie: Movie) {
        let movieImage = imageTransformer?(movie.imageData!)
        let viewModel = MovieViewModel<Image>(title: movie.title,
                                                              overview: movie.overview,
                                                              popularity: "\(movie.popularity)",
                                                              voteAverage: "\(movie.voteAverage)",
                                                                movieThumbImage: movieImage,
                                                              videos: movie.videos ?? [])
        view?.movieDetailFetchedWithSuccess(movie: viewModel)
    }
    
    func presentInitialMovieInfo() {
        view?.displayInitialMovieInfo()
    }
}
