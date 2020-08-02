//
//  MovieManager.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

final class MoviesInteractor {
    var presenter: MoviesInteractorOutput?
    var movies: Dictionary<String, MovieContainer> = Dictionary()
    let moviesLoader: MoviesLoader
    var searchObject: SearchObject
    
    init(moviesLoader: MoviesLoader) {
        self.moviesLoader = moviesLoader
        self.searchObject = SearchObject()
    }
    
    func moviesAreInMemory(searchParams:SearchObject) -> Bool {
        return self.movies.index(forKey: searchParams.category.rawValue) != nil
    }
    
    
    func requestMoviesFromAPI(searchParams: SearchObject) {
        let completionHandler: MoviesFetchCompletion = {[unowned self] (result) in
            
            switch result {
            case .success(let movieContainer):
                if movieContainer.currentPage == 1 {
                    self.movies[searchParams.category.rawValue] = movieContainer
                } else {
                    self.movies[searchParams.category.rawValue]?.update(page: MovieContainer(currentPage: movieContainer.currentPage, totalPages: movieContainer.totalPages, totalResults: movieContainer.totalResults, movies: movieContainer.movies))
                }
                searchParams.page += 1
                
                self.presenter?.moviesFetchedWithSuccess(movieContainer: self.movies[searchParams.category.rawValue]!)
            case .failure(let error):
                self.presenter?.moviesFetchFailed(error: error)
            }
        }
        
        moviesLoader.getMovies(searchParams: searchParams, completion: completionHandler)
    }
}

extension MoviesInteractor: MoviesViewOutput {
    
    func reloadMoviesWith(filterRequest: MoviesFilterRequest) {
        self.searchObject.refreshSearch()
        searchObject.category = filterRequest.category
        searchObject.movieQuery = filterRequest.queryString
        self.fetchMovies()
    }
    
    func reloadMovies() {
        searchObject = SearchObject()
        self.fetchMovies()
    }
    
    func viewDidLoad() {
        self.presenter?.presentInitialState()
        self.fetchMovies()
    }
    
    func fetchMovies() {
        self.requestMoviesFromAPI(searchParams: searchObject)
        self.presenter?.didRequestMovies()
    }
}

