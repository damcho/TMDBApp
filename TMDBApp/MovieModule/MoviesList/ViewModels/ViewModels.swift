//
//  ViewModels.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

struct MoviesListViewModel<Image> {
    let title = "TMDB"
    let movies: [MovieViewModel<Image>]
    
    init(movies: [MovieViewModel<Image>]) {
        self.movies = movies
    }
}

struct MovieViewModel<Image> {
    let movieID: UInt
    let title: String
    let overview: String
    var popularoty: String?
    var voteAverage: String?
    var movieThumbImage: Image?
    var videos: [Video]?

    init(movieID: UInt, title: String, overview: String, popularity: String? = nil, voteAverage: String? = nil, movieThumbImage: Image? = nil, videos: [Video] = [] ) {
        self.title = title
        self.movieID = movieID
        self.overview = overview
        self.movieThumbImage = movieThumbImage
        if let somePopularity = popularity {
            self.popularoty = "\(somePopularity)"
        }
        if let someVoteAverage = voteAverage {
            self.voteAverage = "\(someVoteAverage)"
        }
        self.videos = videos
    }
}
