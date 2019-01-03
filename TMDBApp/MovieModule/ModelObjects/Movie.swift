//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    
    var title:String
    var movieId:Int
    var category:MovieFilter?
    var overview:String
    var popularity:Double
    var voteAverage:Float
    var imageURLPath:String?
    var imageData:Data?

    
    init() {
        self.title = ""
        self.overview = ""
        self.movieId = 0
        self.popularity = 0
        self.voteAverage = 0
    }
    
    init(data:DecodedMovie) {
        self.title = data.title
        self.movieId = data.id
        self.overview = data.overview
        self.popularity = data.popularity
        self.imageURLPath = data.imageURL
        self.voteAverage = data.voteAvg

    }
    
    func setCategory(category:MovieFilter) {
        self.category = category
    }
    
    func getImage(completion: @escaping (UIImage?) -> ()){
        MovieManager.shared.getImage(path: self.imageURLPath!, completion: completion)
    }
}
