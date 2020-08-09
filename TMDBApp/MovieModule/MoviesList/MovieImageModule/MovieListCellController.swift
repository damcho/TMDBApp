//
//  MovieListCellController.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/6/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

final class MovieListCellController: MovieCellPresenterOutput {
    
    var movieCellInteractor: MovieListCellInteractor?
    private var imageLoadingTask: CancelableImageTask?
    var viewModel: MovieViewModel<UIImage>?
    
    var cellView: MovieTableViewCell?{
        didSet {
            imageLoadingTask = movieCellInteractor?.requestImage()
        }
    }
    func preload() {
        imageLoadingTask = movieCellInteractor?.requestImage()
    }
    
    func display(viewModel: MovieViewModel<UIImage>) {
        self.viewModel = viewModel
        cellView?.movieTitleLabel.text = viewModel.title
        cellView?.overViewLabel.text = viewModel.overview
        cellView?.movieImageView.image = viewModel.movieThumbImage ?? UIImage(named: "default")
    }
    
    func releaseCellForReuse() {
        cellView = nil
    }
    
    func cancelTask() {
        releaseCellForReuse()
        imageLoadingTask?.cancel()
    }
}
