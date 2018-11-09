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
    var category:MovieFilter?
    var overview:String
    var popularity:Double

    
    init() {
        self.title = ""
        self.overview = ""
        self.movieId = 0
        self.popularity = 0
    }
    
    init(data:DecodedMovie) {
        self.title = data.title
        self.movieId = data.id
        self.overview = data.overview
        self.popularity = data.popularity

        print(title)
    }
    
    func setCategory(category:MovieFilter) {
        self.category = category
        print(self.category)
    }
    
    func compliesFilter(searchParams:SearchObject) -> Bool{
        return  self.category == searchParams.filter ? true : false

    }
}
