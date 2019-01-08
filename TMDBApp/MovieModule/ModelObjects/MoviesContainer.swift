//
//  MoviePage.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/01/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

struct MoviesContainer {
    
    var currentPage:Int = 0
    var totalPages:Int = 0
    var totalResults:Int = 0
    var movies:[Movie] = []
    
    init?(data:NSDictionary){
        guard let currentPage = data["page"] as? Int else {
            return nil
        }
        self.currentPage = currentPage
        
        guard let totalPages = data["total_pages"] as? Int else {
            return nil
        }
        self.totalPages = totalPages
        
        guard let total_results = data["total_results"] as? Int else {
            return nil
        }
        self.totalResults = total_results
        
        guard let moviesArray:Array<Dictionary<String, Any>> = (data["results"] as? Array) else {
            return nil
        }
        self.movies = moviesArray.compactMap(Movie.init)
    }
    
    mutating func update(page:MoviesContainer) {
        self.currentPage = page.currentPage
        self.totalPages = page.totalPages
        self.totalResults = page.totalResults
        for movie in page.movies {
            if !self.movies.contains(movie) {
                movies.append(movie)
            }
        }
    }
    
    func getMovies() -> [Movie] {
        return movies
    }
    
    
}
