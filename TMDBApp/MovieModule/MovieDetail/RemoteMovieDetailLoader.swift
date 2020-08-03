//
//  RemoteMovieDetailLoader.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/3/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

protocol MovieDetailLoader {
    func getMovieDetail(searchParams: SearchObject, completion:  @escaping (MovieDetailResult) -> ())
}

typealias MovieDetailFetchCompletion = (MovieDetailResult) -> ()

enum MovieDetailResult {
    case success(Movie)
    case failure(TMDBError)
}

final class RemoteMovieDetailLoader: MovieDetailLoader {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getMovieDetail(searchParams: SearchObject, completion:  @escaping (MovieDetailResult) -> ()) {
        guard let url = APIHelper.createURL(searchPath: searchParams.movieDetailUrlPath(), queryItems:searchParams.movieDetailQueryItems() ) else {
            completion(.failure(.MALFORMED_DATA))
            return
        }
        
        client.request(url: url, completion:  { result in
            switch result {
            case .success(let data, let response):
                guard response.statusCode == 200,
                    let codableMovie = try? JSONDecoder().decode(CodableMovie.self, from: data) else {
                        completion(.failure(.MALFORMED_DATA))
                        return
                }
                completion(.success(Movie(title: codableMovie.title,
                                          movieID: codableMovie.movieId,
                                          overview: codableMovie.overview,
                                          imagePath: codableMovie.imageURLString)))
            case .failure(let error):
                completion(.failure(.API_ERROR(reason: error.localizedDescription)))
            }
        })
    }
}
