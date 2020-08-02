//
//  MoviesPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

final class MoviesListPresenter {
    
    weak var moviesListVC: MoviesListPresenterOutput?
}

extension MoviesListPresenter: MoviesInteractorOutput {
    func moviesFetchedWithSuccess(movieContainer:MovieContainer){
        let viewModel = MoviesViewModel(movies: movieContainer.movies)
        self.moviesListVC?.didReceiveMovies(moviesViewModel: viewModel)
    }
    
    func moviesFetchFailed(error:TMDBError){
        self.moviesListVC?.didRetrieveMoviesWithError(error:error)
    }
    
    func presentInitialState() {
        self.moviesListVC?.presentInitialState(screenTitle: "TMDB")
    }
    
    func didRequestMovies() {
        self.moviesListVC?.didRequestMovies()
    }
}
