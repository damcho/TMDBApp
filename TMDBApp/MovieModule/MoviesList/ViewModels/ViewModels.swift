//
//  ViewModels.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

struct MoviesListViewModel<Image> {
    let title = "TMDB"
    let movies: [MovieViewModel<Image>]
    
    init(movies: [MovieViewModel<Image>]) {
        self.movies = movies
    }
}

struct MovieViewModel<Image> {
    let title: String
    let overview: String
    var popularoty: String?
    var voteAverage: String?
    var movieThumbImage: Image?
    var videos: [Video]?

    init(title: String, overview: String, popularity: String? = nil, voteAverage: String? = nil, movieThumbImage: Image? = nil, videos: [Video] = [] ) {
        self.title = title
        self.overview = overview
        self.movieThumbImage = movieThumbImage
        if let somePopularity = popularity {
            self.popularoty = "\(somePopularity)"
        }
        if let someVoteAverage = voteAverage {
            self.voteAverage = "\(someVoteAverage)"
        }
    }
}
