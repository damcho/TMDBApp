//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

struct CodableMovie :Equatable, Codable{
    
    var title:String
    var movieId: UInt
    var overview:String
    var popularity:Double? = 0
    var voteAverage:Double? = 0
    var imageURLString: String
    var videos:[Video]? = []
  
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case movieId = "id"
        case overview = "overview"
        case popularity = "popularity"
        case voteAverage = "vote_average"
        case imageURLString = "poster_path"
        case videos = "videos"
    }
    
    static func == (lhs: CodableMovie, rhs: CodableMovie) -> Bool {
        return lhs.movieId == rhs.movieId
    }
}
