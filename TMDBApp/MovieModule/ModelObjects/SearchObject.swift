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
    
    var filter:MovieFilter
    var page = 1
    
    init() {
        self.filter = .POPULARITY
    }
    
    func urlString() -> String{
        return "/\(filter.rawValue)"
    }
    
    func filterValue(value:Int) {
        switch value {
        case 0:
            self.filter = .TOP_RATED
        case 1:
            self.filter = .UPCOMING
        case 2:
            self.filter = .POPULARITY
        default:
            self.filter = .POPULARITY
        }        
    }
}
