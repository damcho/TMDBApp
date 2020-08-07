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

struct CodableVideoResults: Codable {
    var results: Int?
}

struct CodableMovie: Codable{
    
    var title:String
    var movieId: UInt
    var overview:String
    var popularity:Double?
    var voteAverage:Double?
    var imageURLString: String
    var videos: [String: [Video]]?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case movieId = "id"
        case overview
        case popularity
        case voteAverage = "vote_average"
        case imageURLString = "poster_path"
        case videos
    }
}

private struct RootResult: Codable{
    
    var currentPage: Int
    var totalPages: Int
    var totalResults: Int
    private var codableMovies:[CodableMovie]
    
    var movies: [Movie] {
        return self.codableMovies.map( { Movie(title: $0.title, movieID: $0.movieId, overview: $0.overview, imageURL: URL(string: Constants.baseImageURL + $0.imageURLString)) })
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

enum TMDBError: Error {
    case API_ERROR(reason: String)
    case NOT_FOUND
    case MALFORMED_DATA
    case MALFORMED_URL
    case SERVER_ERROR
}

final class RemoteMoviesLoader{
    
    private let client: HTTPClient
    private var moviesContainer = MoviesContainer()
    
    init(client: HTTPClient) {
        self.client = client
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

extension RemoteMoviesLoader: MoviesLoader {
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
}

private final class MoviesListMapper {
    static func map(_ data: Data) throws -> MoviesContainer{
        let rootResult = try JSONDecoder().decode(RootResult.self, from: data)
        return MoviesContainer(currentPage: rootResult.currentPage,
                               totalPages: rootResult.totalPages,
                               totalResults: rootResult.totalResults,
                               movies: rootResult.movies)
    }
}

private final class MoviesContainer {
    var currentPage: Int
    var totalPages: Int
    var totalResults: Int
    var movies: [Movie]
    
    init(currentPage: Int = 0, totalPages: Int = 0, totalResults: Int = 0, movies: [Movie] = []) {
        self.currentPage = currentPage
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.movies = movies
    }
    
    func update(page: MoviesContainer) {
        self.currentPage = page.currentPage
        self.totalPages = page.totalPages
        self.totalResults = page.totalResults
        for movie in page.movies {
            if !self.movies.contains(movie) {
                movies.append(movie)
            }
        }
    }
}
