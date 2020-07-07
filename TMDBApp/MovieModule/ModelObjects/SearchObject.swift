//
//  SearchObject.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

enum MovieFilterType :String{
    case TOP_RATED = "top_rated"
    case UPCOMING = "upcoming"
    case POPULARITY = "popular"
    case QUERY = "query"

}


class SearchObject {
    
    private let moviePath = "/3/movie"
    private let searchPath = "/3/search/movie"

    var category:MovieFilterType = .QUERY
    var page:Int = 1
    var movie: Movie?
    var movieQuery:String?
    
    func refreshSearch () {
        self.page = 1
    }
    
    func searchMoviesUrlPath() -> String {
        switch self.category {
        case .POPULARITY, .UPCOMING, .TOP_RATED:
            return moviePath + "/\(self.category.rawValue)"
        case .QUERY:
            return searchPath
        }
    }
    
    func searchMoviesQueryItems() -> [URLQueryItem] {
        switch self.category {
        case .POPULARITY, .UPCOMING, .TOP_RATED:
            return [URLQueryItem(name: "page", value: "\(self.page)")]
        case .QUERY:
            guard let movieQuery = self.movieQuery, movieQuery.count > 0 else {
                return []
            }
            return [URLQueryItem(name: "query", value: movieQuery),URLQueryItem(name: "page", value: "\(self.page)") ]
        }
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
    
    func filterValue(value:Int) {
        switch value {
        case 0:
            self.category = .TOP_RATED
        case 1:
            self.category = .UPCOMING
        case 2:
            self.category = .POPULARITY
        default:
            self.category = .QUERY
        }        
    }
}
