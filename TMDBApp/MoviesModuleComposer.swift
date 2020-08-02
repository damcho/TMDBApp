//
//  MoviesModuleComposer.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

final class MoviesModuleComposer {
    static func create() -> MoviesListViewController {
        let moviesListVC = mainstoryboard.instantiateViewController(withIdentifier: "MoviesListViewController") as! MoviesListViewController
        let interactor = MoviesInteractor(moviesLoader: RemoteMoviesLoader(client: AlamoFireHttpClient()))
        let router = MoviesListRouter()
        router.viewController = moviesListVC
        let presenter = MoviesListPresenter()

        moviesListVC.router = router
        moviesListVC.interactor = interactor
        presenter.moviesListVC = moviesListVC
        interactor.presenter = presenter
        
        return moviesListVC
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
