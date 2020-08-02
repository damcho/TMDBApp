//
//  ViewModels.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

struct MoviesListViewModel {
    let title = "TMDB"
    let movies: [MovieViewModel]
    
    init(movies: [MovieViewModel]) {
        self.movies = movies
    }
}

class MovieViewModel {
    var title: String {
        return self.model.title
    }
    let imageLoader: ImageDataLoader
    let model: Movie
    var imageTask: CancelableImageTask?
    var view: MovieTableViewCell? {
        didSet {
            view?.movieTitleLabel.text = model.title
            requestImage()
        }
    }
    
    init(model: Movie) {
        self.model = model
        self.imageLoader = ImageDataLoader(client: AlamoFireHttpClient())
    }
    
    func preload() {
        view?.movieImageView.image = UIImage(named: "default")
        requestImage()
    }
    
    func requestImage() {
        guard let url = model.imageURL else { return }
        self.imageTask = imageLoader.loadImage(from: url) {[weak self] (result) in
            switch result {
            case .success(let data):
                self?.view?.movieImageView.image = UIImage(data: data)
            default:
                break
            }
        }
    }
    
    func releaseCellForReuse() {
        view = nil
    }
    
    func cancelTask() {
        releaseCellForReuse()
        imageTask?.cancel()
    }
}
