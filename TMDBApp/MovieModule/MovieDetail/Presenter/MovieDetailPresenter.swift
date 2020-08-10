//
//  MovieDetailPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class MovieDetailPresenter<PresenterOutput: MovieDetailPresenterOutput, Image> where PresenterOutput.Image == Image {
    weak var view: PresenterOutput?
    var imageTransformer: (Data) -> Image?
    
    init(view: PresenterOutput, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
}

extension MovieDetailPresenter: MovieDetailInteractorOutput {
    func presentDataFor(_ movie: Movie) {
        var movieImage: Image?
        if let imageData = movie.imageData {
            movieImage = imageTransformer(imageData)
        }
        let viewModel = MovieViewModel<Image>(movieID: movie.movieId, title: movie.title,
                                              overview: movie.overview,
                                              popularity: movie.popularity,
                                              voteAverage: movie.voteAverage,
                                              movieThumbImage: movieImage,
                                              videos: movie.videos ?? [])
        view?.displayMovieInfo(viewModel: viewModel)
    }
}
