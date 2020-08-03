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

struct FilterDataObject {

    var category: MovieFilterType = .TOP_RATED
    var movieID: String?
    var movieNameQueryString: String?
    var shouldRefresh: Bool?

    /*
    func movieDetailUrlPath() -> String {
        guard let movie = self.movie else {
            return ""
        }
        return moviePath+"/\( movie.movieId )"
    }
    func movieDetailQueryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "append_to_response", value: "videos")]
    }
 */

}
