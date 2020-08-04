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
    var presenter: MovieDetailInteractorOutput!
    
    init(movieDetailLoader: MovieDetailLoader) {
        self.movieDetailLoader = movieDetailLoader
    }
    
    func fetchMovieDetailFor(_ movieID: String) {
        
        movieDetailLoader.getMovieDetail(movieID: movieID, completion: { result in
            switch result {
            case .success(let movie):
                self.presenter.presentFullMovieDetail(movie: movie)
            case .failure(let error):
                break
            }
        })
    }
    
    func viewDidLoad() {
        presenter.presentInitialMovieInfo(movie: movie)
    }
    
}
