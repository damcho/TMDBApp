//
//  HelperClasses.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/10/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

final class WeakyFyedInstance<T: AnyObject> {
    private weak var instance: T?
    
    init(_ instance: T) {
        self.instance = instance
    }
}

extension WeakyFyedInstance: MovieDetailPresenterOutput where T: MovieDetailPresenterOutput, T.Image == UIImage {
    func displayMovieInfo(viewModel: MovieViewModel<UIImage>) {
        instance?.displayMovieInfo(viewModel: viewModel)
    }
    func movieDetailFetchedWithError(error: TMDBError) {
        instance?.movieDetailFetchedWithError(error: error)
    }
}

extension WeakyFyedInstance: MoviesListPresenterOutput where T: MoviesListPresenterOutput {
    func didReceiveMovies(movieCellControllers: [MovieListCellController]) {
        instance?.didReceiveMovies(movieCellControllers: movieCellControllers)
    }
    
    func didReceiveEmptyMovieResults() {
        instance?.didReceiveEmptyMovieResults()
    }
    
    func didReceiveError(error: ErrorViewModel) {
        instance?.didReceiveError(error: error)
    }
    
    func presentInitialState(screenTitle: String) {
        instance?.presentInitialState(screenTitle: screenTitle)
    }
    
    func didRequestMovies() {
        instance?.didRequestMovies()
    }
}
