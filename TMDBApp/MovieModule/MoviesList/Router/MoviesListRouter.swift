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
    
    func pushToMovieDetail(movie:Movie) {
        let movieDetailVC = MoviesListRouter.mainstoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.movie = movie
        viewController?.navigationController?.pushViewController(movieDetailVC,animated: true)
    }
}
