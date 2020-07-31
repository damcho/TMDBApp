//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/7/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

struct Movie: Equatable {
    var title:String
    var movieId: UInt
    var overview:String
    var popularity:Double? = 0
    var voteAverage:Double? = 0
    var imagePath: String?
    var videos:[Video]? = []
    
    init(title: String, movieID: UInt, overview: String, imagePath: String?) {
        self.movieId = movieID
        self.title = title
        self.overview = overview
        self.imagePath = imagePath
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.movieId == rhs.movieId
    }
}
