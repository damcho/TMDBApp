//
//  MovieDetailInteractor.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class MovieDetailInteractor {
    let movieDetailLoader: MovieDetailLoader
    var movie: Movie!
    private var imageLoader: ImageLoader
    var presenter: MovieDetailInteractorOutput!
    
    init(movieDetailLoader: MovieDetailLoader, imageLoader: ImageLoader) {
        self.movieDetailLoader = movieDetailLoader
        self.imageLoader = imageLoader
    }
    
    private func fetchMovieDetail() {
        movieDetailLoader.getMovieDetail(movieID: "\(movie.movieId)", completion: {[weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let movie):
                self?.movie = movie
                self?.presenter.presentDataFor((self?.movie)!)
                self?.fetchMovieImageForMovie((self?.movie)!)
            case .failure:
                break
            }
        })
    }
    
    private func fetchMovieImageForMovie(_ movie: Movie) {
        _ = self.imageLoader.loadImage(from: movie.imageURL!) {[weak self] (result) in
            guard self != nil else { return }

            switch result {
            case .success(let imageData):
                self?.movie.imageData = imageData
                self?.presenter.presentDataFor((self?.movie)!)
            default:
                break
            }
        }
    }
}

extension MovieDetailInteractor: MovieDetailViewOutput {
    func viewDidLoad() {
        presenter.presentDataFor(movie)
        fetchMovieDetail()
    }
}
