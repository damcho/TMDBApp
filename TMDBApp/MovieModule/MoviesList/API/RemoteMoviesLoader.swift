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
    func getMovies(searchParams: FilterDataObject, completion:  @escaping MoviesFetchCompletion)
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
    case success([Movie])
    case failure(TMDBError)
}

final class RemoteMoviesLoader: MoviesLoader{
    
    private let client: HTTPClient
    private var moviesContainer = MoviesContainer()
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func getMovies(searchParams: FilterDataObject, completion:  @escaping MoviesFetchCompletion) {
        let searchPath = searchMoviesUrlPathFor(filter: searchParams.category)
        let queryItems = searchMoviesQueryItemsFor(queryString: searchParams.movieNameQueryString)
        
        guard let url = URLFactory.createURL(searchPath: searchPath,
                                             queryItems: queryItems) else {
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
            
            self.moviesContainer.update(page: MoviesContainer(currentPage: moviesContainer.currentPage,
                                                              totalPages: moviesContainer.totalPages,
                                                              totalResults: moviesContainer.totalResults,
                                                              movies: moviesContainer.movies))
            
            return .success(self.moviesContainer.movies)
        } catch {
            return .failure(TMDBError.MALFORMED_DATA)
        }
    }
    
    private func searchMoviesUrlPathFor(filter: MovieFilterType) -> String {
        switch filter {
        case .POPULARITY, .UPCOMING, .TOP_RATED:
            return Constants.moviePath + "/\(filter.rawValue)"
        case .QUERY:
            return Constants.searchPath
        }
    }
    
    private func searchMoviesQueryItemsFor(queryString: String?) -> [URLQueryItem] {
        var queryItems =  [URLQueryItem(name: "page", value: "\(self.moviesContainer.currentPage + 1)")]
        guard let string = queryString else { return queryItems }
        
        queryItems.append( URLQueryItem(name: "query", value: string))
        return queryItems
    }
}

private class URLFactory {
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

private class MoviesListMapper {
    static func map(_ data: Data) throws -> MoviesContainer{
        let rootResult = try JSONDecoder().decode(RootResult.self, from: data)
        return MoviesContainer(currentPage: rootResult.currentPage,
                               totalPages: rootResult.totalPages,
                               totalResults: rootResult.totalResults,
                               movies: rootResult.movies)
    }
}
