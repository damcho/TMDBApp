//
//  MoviesPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 08/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

struct ErrorViewModel {
    let errorDescription: String
}

final class MoviesListPresenter {
    weak var moviesListVC: MoviesListPresenterOutput?
}

extension MoviesListPresenter: MoviesInteractorOutput {
    func moviesFetchedWithSuccess(movies: [Movie]){
        if movies.isEmpty {
            moviesListVC?.didReceiveEmptyMovieReslts()
        } else {
            let cellControllers: [MovieListCellController] = movies.map { (movie) in
                let cellController = MovieListCellController()
                let cellInteractor = MovieListCellInteractor(imageLoader: ImageDataLoader(client: AlamoFireHttpClient()))
                let cellPresenter = MovieListCellPresenter<MovieListCellController, UIImage>(cellController: cellController, imageTransformer: UIImage.init)
                cellPresenter.cellController = cellController
                
                cellInteractor.movieCellPresenter = cellPresenter
                cellInteractor.movie = movie
                
                cellController.movieCellInteractor = cellInteractor
                
                return cellController
            }
            self.moviesListVC?.didReceiveMovies(movieCellControllers: cellControllers)
        }
    }
    
    func moviesFetchFailed(error:TMDBError){
        var errorViewModel: ErrorViewModel?
        switch error {
        case .CONNECTIVITY:
            moviesListVC?.didRetrieveMoviesWithError(error: ErrorViewModel(errorDescription: "The connection appears to be offline"))
        default:
            break
        }
    }
    
    func presentInitialState() {
        self.moviesListVC?.presentInitialState(screenTitle: "TMDB")
    }
    
    func didRequestMovies() {
        self.moviesListVC?.didRequestMovies()
    }
}
