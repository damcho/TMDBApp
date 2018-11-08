//
//  MovieObjectDecoder.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class MovieObjectDecoder {
    
    static func decode(data:Data) throws ->  [Movie]  {
        let decodedMovies =  try  JSONDecoder().decode(DecodedMovies.self, from: data)
        var results:Array<Movie> = Array()
        for decodedMovie in decodedMovies.results {
            results.append(Movie(data:decodedMovie))
        }
        
        return results
    }
}


private struct DecodedMovies:Decodable {
    
    let results:[DecodedMovie]
    
}

struct DecodedMovie: Decodable {
    
    let title:String
    
    enum CodingKeys : String, CodingKey {
        
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
    }
}
