//
//  MovieDetailProtocol.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/4/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

protocol MovieDetailDelegate: class {
    func movieDetailFetchedWithSuccess(movie: Movie)
    func movieDetailFetchedWithError(error: TMDBError)
}
