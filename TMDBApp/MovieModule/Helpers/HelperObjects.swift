//
//  HelperObjects.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public struct AFHTTPError: Codable {
    var status_message: String?
}

public enum HTTPError: Error {
    case notFound
    case unknownError
    case connectionError
    case customError(AFHTTPError)
}

enum TMDBError: Error {
    case API_ERROR(reason:String)
    case NOT_FOUND
    case MALFORMED_DATA
    case MALFORMED_URL
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(HTTPError)
}

struct MoviesFilterRequest {
    let category: MovieFilterType
    let queryString: String
    
    init(filterCategory: Int = 3, queryString: String = "") {
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
