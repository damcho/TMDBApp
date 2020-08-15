//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/7/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

struct Movie: Equatable {
    var title: String
    var movieId: UInt
    var overview: String
    var popularity: Double?
    var voteAverage: Double?
    var posterImageUrl: URL?
    var backImageUrl: URL?
    var videos: [Video]?
    var imageData: Data?
    
    init(title: String, movieID: UInt, overview: String, posterImageUrl: URL? = nil, backImageUrl: URL? = nil, voteAverage: Double? = nil, popularity: Double? = nil, videos: [Video]? = nil) {
        self.movieId = movieID
        self.title = title
        self.overview = overview
        self.posterImageUrl = posterImageUrl
        self.voteAverage = voteAverage
        self.popularity = popularity
        self.videos = videos
        self.backImageUrl = backImageUrl
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.movieId == rhs.movieId
    }
}
