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
    
    private let moviePath = "/3/movie"
    private let searchPath = "/search/movie?"

    var category:MovieFilter = .POPULARITY
    var page:Int = 1
    var movie:Movie?
    var movieQuery:String?
    
    func refreshSearch () {
        self.page = 1
    }
    
    func searchMoviesUrlPath() -> String {
        return moviePath + "/\(self.category.rawValue)"
    }
    
    func searchMoviesQueryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "page", value: "\(self.page)")]
    }
    
    func movieDetailUrlPath() -> String {
        guard let movie = self.movie else {
            return ""
        }
        return moviePath+"/\( movie.movieId )"
    }
    
    func movieDetailQueryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "append_to_response", value: "videos")]
    }
    
    func moviesQueryUrl() -> String {
        guard let movieQuery = self.movieQuery else {
            return ""
        }
        return searchPath+"?query="+movieQuery
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
