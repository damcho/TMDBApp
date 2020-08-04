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
    
    func pushToMovieDetail(movie: MovieViewModel) {
        let movieDetailViewController = MovieDetailComposer.compose(movie: movie)
        viewController?.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
