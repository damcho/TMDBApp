//
//  TMDBAPIConnector.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

typealias MoviesFetchCompletion = (IMDBResult) -> ()

protocol MoviesLoader {
    func getMovies(searchParams: SearchObject, completion:  @escaping MoviesFetchCompletion)
}

struct CodableMovie: Codable{
    
    var title:String
    var movieId: UInt
    var overview:String
    var popularity:Double? = 0
    var voteAverage:Double? = 0
    var imageURLString: String
    var videos:[Video]? = []
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case movieId = "id"
        case overview
        case popularity
        case voteAverage = "vote_average"
        case imageURLString = "poster_path"
        case videos = "videos"
    }
}

private struct RootResult: Codable{
    
    var currentPage: Int
    var totalPages: Int
    var totalResults: Int
    private var codableMovies:[CodableMovie]
    
    var movies: [Movie] {
        return self.codableMovies.map( { Movie(title: $0.title, movieID: $0.movieId, overview: $0.overview, imagePath: $0.imageURLString) })
    }
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case codableMovies = "results"
    }
}

enum IMDBResult {
    case success(MoviesContainer)
    case failure(TMDBError)
}

final class RemoteMoviesLoader: MoviesLoader{
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getMovies(searchParams: SearchObject, completion:  @escaping MoviesFetchCompletion) {
        guard let url = APIHelper.createURL(searchPath: searchParams.searchMoviesUrlPath(), queryItems:searchParams.searchMoviesQueryItems() ) else {
            completion(.failure(.MALFORMED_URL))
            return
        }
        
        client.request(url: url, completion: { result in
            switch result {
            case .success(let data, let response):
                completion(self.mapMovies(data: data, response: response))
            case .failure(let error):
                completion(.failure(.API_ERROR(reason: error.localizedDescription)))
            }
        })
    }
    
    private func mapMovies(data: Data, response: HTTPURLResponse) -> IMDBResult {
        guard response.statusCode == 200 else {
            return .failure(TMDBError.API_ERROR(reason: "unknown error"))
        }
        do {
            let moviesContainer = try MoviesListMapper.map(data)
            return .success(moviesContainer)
        } catch {
            return .failure(TMDBError.MALFORMED_DATA)
        }
    }
}

private class MoviesListMapper {
    static func map(_ data: Data) throws -> MoviesContainer{
        let rootResult = try JSONDecoder().decode(RootResult.self, from: data)
        return MoviesContainer(currentPage: rootResult.currentPage,
                               totalPages: rootResult.totalPages,
                               totalResults: rootResult.totalResults,
                               movies: rootResult.movies)
    }
}
