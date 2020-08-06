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
    var imageURL: URL?
    var videos: [Video]? = []
    var imageData: Data?
    
    init(title: String, movieID: UInt, overview: String, imageURL: URL? = nil) {
        self.movieId = movieID
        self.title = title
        self.overview = overview
        self.imageURL = imageURL
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.movieId == rhs.movieId
    }
}
