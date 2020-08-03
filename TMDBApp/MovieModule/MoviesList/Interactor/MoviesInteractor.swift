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
    let moviesLoader: MoviesLoader
    var searchObject: FilterDataObject
    
    init(moviesLoader: MoviesLoader) {
        self.moviesLoader = moviesLoader
        self.searchObject = FilterDataObject()
    }
    
    func requestMoviesFromAPI(searchParams: FilterDataObject) {
        let completionHandler: MoviesFetchCompletion = {[unowned self] (result) in
            
            switch result {
            case .success(let movies):
                self.presenter?.moviesFetchedWithSuccess(movies: movies)
            case .failure(let error):
                self.presenter?.moviesFetchFailed(error: error)
            }
        }
        
        moviesLoader.getMovies(searchParams: searchParams, completion: completionHandler)
    }
}

extension MoviesInteractor: MoviesViewOutput {
    
    func reloadMoviesWith(filterRequest: MoviesFilterRequest) {
        searchObject.category = filterRequest.category
        searchObject.movieNameQueryString = filterRequest.queryString
        self.fetchMovies()
    }
    
    func reloadMovies() {
        searchObject = FilterDataObject()
        self.fetchMovies()
    }
    
    func viewDidLoad() {
        self.presenter?.presentInitialState()
        self.fetchMovies()
        self.presenter?.didRequestMovies()
    }
    
    func fetchMovies() {
        self.requestMoviesFromAPI(searchParams: searchObject)
    }
}

