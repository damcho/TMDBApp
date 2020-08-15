//
//  RemoteMovieDetailLoader.swift
//  TMDBApp
//
//  Created by Damian Modernell on 8/3/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

protocol MovieDetailLoader {
    func getMovieDetail(movieID: String, completion:  @escaping (MovieDetailResult) -> ())
}

typealias MovieDetailFetchCompletion = (MovieDetailResult) -> ()

enum MovieDetailResult {
    case success(Movie)
    case failure(TMDBError)
}

final class RemoteMovieDetailLoader {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    private func map(data: Data, response: HTTPURLResponse) -> MovieDetailResult {
        do {
            return .success( try MovieDetailMapper.map(data: data))
        } catch {
            return .failure(.MALFORMED_DATA)
        }
    }
    
    
    private func movieDetailUrlPathFor(movieID: String) -> String {
        return Constants.moviePath+"/\( movieID )"
    }
    private func movieDetailQueryItems() -> [URLQueryItem] {
        return [URLQueryItem(name: "append_to_response", value: "videos")]
    }
}

extension RemoteMovieDetailLoader: MovieDetailLoader {
    func getMovieDetail(movieID: String, completion:  @escaping (MovieDetailResult) -> ()) {
        guard let url = URLFactory.createURL(searchPath: movieDetailUrlPathFor(movieID: movieID), queryItems: movieDetailQueryItems() ) else {
            completion(.failure(.MALFORMED_URL))
            return
        }
        
        client.request(url: url, completion:  { result in
            switch result {
            case .success(let data, let response):
                completion(self.map(data: data, response: response))
            case .failure:
                completion(.failure(.CONNECTIVITY))
            }
        })
    }
}

private class MovieDetailMapper {
    static func map(data: Data) throws -> Movie{
        let codableMovie = try JSONDecoder().decode(CodableMovie.self, from: data)
        return Movie(title: codableMovie.title,
                     movieID: codableMovie.movieId,
                     overview: codableMovie.overview,
                     posterImageUrl: URL(string: Constants.baseImageURL + (codableMovie.posterImageUrl ?? "")),
                     backImageUrl: URL(string: Constants.baseImageURL + (codableMovie.backdropImageUrl ?? "")),
                     voteAverage: codableMovie.voteAverage,
                     popularity: codableMovie.popularity,
                     videos: codableMovie.videos)
    }
}
