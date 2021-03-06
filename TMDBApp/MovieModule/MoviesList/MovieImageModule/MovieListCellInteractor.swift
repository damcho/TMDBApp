//
//  MovieListCellInteractor.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/6/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class MovieListCellInteractor {
    
    var movie: Movie!
    let imageloader: ImageLoader
    var movieCellPresenter: MovieImageInteractorOutput!
    
    init(imageLoader: ImageLoader) {
        self.imageloader = imageLoader
    }
}

extension MovieListCellInteractor: MovieImageViewOutput {
    func requestImage() -> CancelableImageTask? {
        self.movieCellPresenter.didRequestImageforMovie(movie)
        guard let url = movie.posterImageUrl else { return nil }
        return imageloader.loadImage(from: url) {[weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .success(let data):
                self?.movieCellPresenter.didFinishLoadingImage(imageData: data, for: (self?.movie)!)
            case .failure(let error):
                self?.movieCellPresenter.didFailToLoadImage(error: error)
            }
        }
    }
}

