//
//  Protocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/6/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

protocol MovieImageInteractorOutput {
    func didRequestImageforMovie(_ movie: Movie)
    func didFinishLoadingImage(imageData: Data, for movie: Movie)
    func didFailToLoadImage(error: Error)
}

protocol MovieCellPresenterOutput: class {
    associatedtype Image
    func display(viewModel: MovieViewModel<Image>)
}

protocol MovieImageViewOutput: class {
    func requestImage() -> CancelableImageTask?
}

