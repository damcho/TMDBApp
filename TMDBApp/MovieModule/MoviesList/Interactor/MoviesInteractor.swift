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
        moviesLoader.getMovies(searchParams: searchParams, completion: {[weak self] (result) in
            guard self != nil else{ return }
            switch result {
            case .success(let movies):
                self?.searchObject.shouldRefresh = false
                self?.presenter?.moviesFetchedWithSuccess(movies: movies)
            case .failure(let error):
                self?.presenter?.moviesFetchFailed(error: error)
            }
        })
    }
}

extension MoviesInteractor: MoviesViewOutput {

    func reloadMoviesWith(filterRequest: MoviesFilterRequest) {
        searchObject.category = filterRequest.category
        searchObject.movieNameQueryString = filterRequest.queryString
        searchObject.shouldRefresh = true
        self.fetchMovies()
    }
    
    func reloadMovies() {
        searchObject = FilterDataObject()
        searchObject.shouldRefresh = true
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

