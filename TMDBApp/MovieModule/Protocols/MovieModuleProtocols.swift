//
//  MovieModuleProtocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

typealias QueryResut = ([Movie]?, Error?) -> ()


protocol DataConnector {
    
    func getMovies(searchParams: SearchObject, completion: @escaping QueryResut )
    
    
}
