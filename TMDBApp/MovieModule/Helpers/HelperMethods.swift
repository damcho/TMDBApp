//
//  HelperMethods.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/3/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

final class APIHelper {
    static func createURL(searchPath:String, queryItems:[URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = searchPath
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: Constants.APIKey)]
        if queryItems != nil {
            urlComponents.queryItems!.append(contentsOf: queryItems!)
        }
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
}
