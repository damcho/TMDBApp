//
//  MovieModuleRouter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

class MovieModuleRouter {
    
    
    static func createModule() -> UIViewController {
        
        let moviesListVC = mainstoryboard.instantiateViewController(withIdentifier: "MoviesListViewController") as! MoviesListViewController
        
        let presenter = MoviesPresenter()
        let manager = MovieManager()
        let router = MovieModuleRouter()
                
        moviesListVC.presenter = presenter
        presenter.moviesListVC = moviesListVC
        presenter.router = router
        presenter.movieManager = manager
        manager.presenter = presenter
        
        return moviesListVC
        
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushToMovieDetailScreen(navigationConroller navigationController:UINavigationController) {
        
        let movieDetailVC = MovieModuleRouter.mainstoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        navigationController.pushViewController(movieDetailVC,animated: true)
        
    }
    
    func pushToMovieDetail(navController:UINavigationController, movie:Movie) {
        let movieDetailVC = MovieModuleRouter.mainstoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailVC.movie = movie
        navController.pushViewController(movieDetailVC,animated: true)
    }
}
