//
//  MovieListCellPresenter.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/6/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class MovieListCellPresenter<CellController: MovieCellPresenterOutput, Image> where CellController.Image == Image {
    
    weak var cellController: CellController?
    var imageTransformer: (Data) -> Image?
    
    init(cellController: CellController, imageTransformer: @escaping (Data) -> Image?) {
        self.cellController = cellController
        self.imageTransformer = imageTransformer
    }
}

extension MovieListCellPresenter: MovieImageInteractorOutput {
    func didRequestImageforMovie(_ movie: Movie) {
        let movieCellViewModel = MovieViewModel<CellController.Image>(
            movieID: movie.movieId, title: movie.title,
            overview: movie.overview)
        
        cellController?.display(viewModel: movieCellViewModel)
    }
    
    func didFinishLoadingImage(imageData: Data, for movie: Movie) {
        let movieImage =  imageTransformer(imageData)
        let movieCellViewModel = MovieViewModel<CellController.Image>(
            movieID: movie.movieId, title: movie.title,
            overview: movie.overview,
            movieThumbImage: movieImage)
            
        cellController?.display(viewModel: movieCellViewModel)
    }
    
    func didFailToLoadImage(error: Error) {
        
    }
}
