//
//  TMDBAPIConnector.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

typealias MoviesFetchCompletion = (IMDBResult) -> ()
typealias MovieDetailFetchCompletion = (MovieDetailResult) -> ()

protocol MoviesLoader {
    func getMovies(searchParams: SearchObject, completion:  @escaping (IMDBResult) -> ())
    func getMovieDetail(searchParams: SearchObject, completion:  @escaping (MovieDetailResult) -> ())
}

public protocol HTTPClient {
    @discardableResult
    func request(url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask
}

public protocol HTTPClientTask {
    func cancel()
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

class RootResult: Codable{
    
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


enum TMDBError: Error {
    case API_ERROR(reason:String)
    case NOT_FOUND
    case MALFORMED_DATA
}

enum IMDBError: Error {
    case invalidData
    case connection
}

public struct AFHTTPError: Codable {
    var status_message: String?
}

public enum HTTPError: Error {
    case notFound
    case unknownError
    case connectionError
    case customError(AFHTTPError)
}

enum IMDBResult {
    case success(MovieContainer)
    case failure(TMDBError)
}

enum MovieDetailResult {
    case success(Movie)
    case failure(TMDBError)
}

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(HTTPError)
}

final class RemoteMoviesLoader: MoviesLoader{
    
    private let host = "api.themoviedb.org"
    private let scheme = "https"
    
    private let APIKey:String = "df2fffd5a0084a58bde8be99efd54ec0"
    private let imageBaseURL:String = "https://image.tmdb.org/t/p/w300"
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getMovies(searchParams: SearchObject, completion:  @escaping (IMDBResult) -> ()) {
        guard let url = createURL(searchPath: searchParams.searchMoviesUrlPath() , queryItems:searchParams.searchMoviesQueryItems() ) else {
            return
        }
        
        let completionHandler: (HTTPClientResult) -> Void = { (result) in
            switch result {
            case .success(let data, let response):
                guard response.statusCode == 200,
                    let rootResult = try? JSONDecoder().decode(RootResult.self, from: data) else {
                    completion(.failure(.MALFORMED_DATA))
                    return
                }
                completion(.success(MovieContainer(currentPage: rootResult.currentPage,
                                                   totalPages: rootResult.totalPages,
                                                   totalResults: rootResult.totalResults,
                                                   movies: rootResult.movies)))
            case .failure(let error):
                completion(.failure(.API_ERROR(reason: error.localizedDescription)))
            }
        }
        
        client.request(url: url, completion: completionHandler)
    }
    
    func getMovieDetail(searchParams: SearchObject, completion:  @escaping (MovieDetailResult) -> ()) {
        guard let url = createURL(searchPath: searchParams.movieDetailUrlPath(), queryItems:searchParams.movieDetailQueryItems() ) else {
            return
        }
        
        let completionHandler = { (result: HTTPClientResult) in
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
        }
        
        client.request(url: url, completion: completionHandler)
    }
    
    private func createURL(searchPath:String, queryItems:[URLQueryItem]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = searchPath
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: APIKey)]
        if queryItems != nil {
            urlComponents.queryItems!.append(contentsOf: queryItems!)
        }
        
        guard let url = urlComponents.url else { return nil }
        return url
    }
}

