//
//  MovieModuleRouter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

final class MoviesListRouter: MoviesListRoutes{
    weak var viewController: MoviesListViewController?
        
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushToMovieDetail(movie: MovieViewModel) {
        let movieDetailViewController = MoviesListRouter.mainstoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailViewController.movie = movie
        
        let movieDetailInteractor = MovieDetailInteractor(
            movieDetailLoader: RemoteMovieDetailLoader(
                client: AlamoFireHttpClient()))
        let movieDetailPresenter = MovieDetailPresenter()
        movieDetailInteractor.presenter = movieDetailPresenter
        movieDetailInteractor.movie = movie.model
        movieDetailViewController.interactor = movieDetailInteractor
        
        viewController?.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
