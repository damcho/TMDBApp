//
//  SearchObject.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

enum MovieFilter :String{
    case TOP_RATED = "top_rated"
    case UPCOMING = "upcoming"
    case POPULARITY = "popular"
}


class SearchObject {
    
    var category:MovieFilter
    var page = 1
    
    init() {
        self.category = .POPULARITY
    }
    
    func urlString() -> String{
        return "/\(category.rawValue)"
    }
    
    func filterValue(value:Int) {
        switch value {
        case 0:
            self.category = .TOP_RATED
        case 1:
            self.category = .UPCOMING
        case 2:
            self.category = .POPULARITY
        default:
            self.category = .POPULARITY
        }        
    }
}
