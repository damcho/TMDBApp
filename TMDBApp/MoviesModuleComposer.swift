//
//  MoviesModuleComposer.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class MoviesModuleComposer {
    static func create() -> MoviesListViewController {
        let moviesListViewController: MoviesListViewController = MoviesListViewController.loadFromStoryboard()
        let interactor = MoviesInteractor(moviesLoader: RemoteMoviesLoader(client: AlamoFireHttpClient()))
        let router = MoviesListRouter()
        router.viewController = moviesListViewController
        let presenter = MoviesListPresenter()

        moviesListViewController.router = router
        moviesListViewController.interactor = interactor
        presenter.moviesListVC = WeakyFyedInstance(moviesListViewController)
        interactor.presenter = presenter
        
        return moviesListViewController
    }
}
