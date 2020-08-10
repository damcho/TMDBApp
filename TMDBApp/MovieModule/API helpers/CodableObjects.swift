//
//  CodableObjects.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/8/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

struct CodableVideo: Codable {
    
    let id:String
    let title:String
    
    enum CodingKeys: String, CodingKey {
         case id = "key"
         case title = "name"
     }
}

struct CodableVideosResult: Codable {
    var results: [CodableVideo]
}


struct CodableMovie: Codable{
    
    var title:String
    var movieId: UInt
    var overview:String
    var popularity:Double?
    var voteAverage:Double?
    var imageURLString: String?
    private var codableVideosResult: CodableVideosResult?
    
    var videos: [Video]? {
        return codableVideosResult?.results.map { codableVideo in
            return Video(id: codableVideo.id, title: codableVideo.title)
        }
    }
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case movieId = "id"
        case overview
        case popularity
        case voteAverage = "vote_average"
        case imageURLString = "poster_path"
        case codableVideosResult = "videos"
    }
}

struct RootResult: Codable{
    
    var currentPage: Int
    var totalPages: Int
    var totalResults: Int
    private var codableMovies: [CodableMovie]
    
    var movies: [Movie] {
        return self.codableMovies.map( { Movie(title: $0.title, movieID: $0.movieId, overview: $0.overview, imageURL: URL(string: Constants.baseImageURL + ($0.imageURLString ?? ""))) })
    }
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case codableMovies = "results"
    }
}
