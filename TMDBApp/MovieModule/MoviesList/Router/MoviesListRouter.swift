//
//  MovieModuleRouter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

protocol MoviesListRoutes {
    func pushToMovieDetail(viewModel: MovieViewModel<UIImage>)
}

final class MoviesListRouter: MoviesListRoutes{
    weak var viewController: MoviesListViewController?
    
    func pushToMovieDetail(viewModel: MovieViewModel<UIImage>) {
        let movieDetailViewController = MovieDetailComposer.compose(viewModel: viewModel)
        viewController?.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}
