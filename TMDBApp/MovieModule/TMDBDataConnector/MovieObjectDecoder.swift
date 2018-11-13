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
    
    static func decodeError(data:Data) throws -> Error {
        let decodedError =  try  JSONDecoder().decode(DecodedError.self, from: data)
        let error = NSError(domain: "", code: decodedError.errorCode, userInfo: [NSLocalizedDescriptionKey:decodedError.errorDescription ])
        return error
    }
}


private struct DecodedMovies:Decodable {
    let results:[DecodedMovie]
}

struct DecodedMovie: Decodable {
    
    let title:String
    let id:Int
    let overview:String
    let popularity:Double
    let imageURL:String
    let voteAvg:Float
    
    enum CodingKeys : String, CodingKey {
        
        case title = "title"
        case id = "id"
        case overview = "overview"
        case popularity = "popularity"
        case imageURL = "poster_path"
        case voteAvg = "vote_average"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.id = try container.decode(Int.self, forKey: .id)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        self.voteAvg = try container.decode(Float.self, forKey: .voteAvg)
    }
}

struct DecodedError: Decodable {
    let errorCode:Int
    let errorDescription:String
    
    enum CodingKeys : String, CodingKey {
        
        case errorcode = "status_code"
        case errordesc = "status_message"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errorDescription = try container.decode(String.self, forKey: .errordesc)
        self.errorCode = try container.decode(Int.self, forKey: .errorcode)
    }
}

