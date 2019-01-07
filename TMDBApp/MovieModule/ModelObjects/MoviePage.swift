//
//  MoviePage.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/01/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

struct MoviePage {
    
    let currentPage:Int
    let totalPages:Int
    let totalResults:Int
    var movies:[Movie]
    
    init(movies:[Movie]) {
        self.movies = movies
        currentPage = 1
        totalResults = movies.count
        totalPages = 1
    }
    
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
        let movies:[Movie] = moviesArray.compactMap(Movie.init)

        self.movies = movies
        
        
    }
    
}
