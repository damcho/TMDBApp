//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class Movie {
    
    let title:String
    init(data:DecodedMovie) {
        self.title = data.title
        print(title)
    }
}
