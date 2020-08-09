//
//  HelperObjects.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

struct MoviesFilterRequest {
    let category: MovieFilterType
    let queryString: String?
    
    init(filterCategory: Int = 3, queryString: String? = nil) {
        self.queryString = queryString
        switch filterCategory {
        case 0:
            category = .TOP_RATED
        case 1:
            category = .UPCOMING
        case 2:
            category = .POPULARITY
        default:
            category = .QUERY
        }
    }
}
