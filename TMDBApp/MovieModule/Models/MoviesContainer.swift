//
//  MoviesContainer.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/7/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public final class MoviesContainer {
    var currentPage: Int
    var totalPages: Int
    var totalResults: Int
    var movies: [Movie] = []
    
    init(currentPage: Int, totalPages: Int, totalResults: Int, movies: [Movie]) {
        self.currentPage = currentPage
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.movies = movies
    }
    
    func update(page: MoviesContainer) {
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
