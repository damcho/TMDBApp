//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class Movie {
    
    var title:String
    var movieId:Int
    
    init() {
        self.title = ""
        self.movieId = 0
    }
    
    init(data:DecodedMovie) {
        self.title = data.title
        self.movieId = data.id

        print(title)
    }
}
