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
    
    
    static func createModule() -> MoviesListViewController? {
        
     //   let view = mainstoryboard.instantiateViewController(withIdentifier: "MoviesListViewController") as! MoviesListViewController
        
        let presenter = MoviesPresenter()
        let manager = MovieManager()
        let router = MovieModuleRouter()
        
        let completion = { (error:Error?) ->() in
            
            
        }
        manager.getMovies(searchParams: SearchObject(), completionHandler: completion)
        
   //     view.presenter = presenter
    //    presenter.moviesListVC = view
        presenter.router = router
        presenter.movieManager = manager
        manager.presenter = presenter
        
        return nil
        
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    func pushToMovieDetailScreen(navigationConroller navigationController:UINavigationController) {
        
        let movieDetailVC = MovieModuleRouter.mainstoryboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        navigationController.pushViewController(movieDetailVC,animated: true)
        
    }
}
