//
//  SearchObject.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

enum MovieFilter :String{
    case TOP_RATED
    case POPULAR
    case UPCOMING
}


class SearchObject {
    
    var filter:MovieFilter
    
    init() {
        self.filter = MovieFilter.TOP_RATED
    }
    
    func urlString() -> String{
        return "&sort_by=popularity.desc"
    }
    
    
}
