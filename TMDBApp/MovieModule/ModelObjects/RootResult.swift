//
//  MoviePage.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/01/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation


class RootResult: Codable{
    
    var currentPage: Int
    var totalPages: Int
    var totalResults: Int
    var codableMovies:[CodableMovie]

    var movies: [Movie] {
        return self.codableMovies.map( { Movie(title: $0.title, movieID: $0.movieId, overview: $0.overview, imagePath: $0.imageURLString) })
    }
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case codableMovies = "results"
    }
}
