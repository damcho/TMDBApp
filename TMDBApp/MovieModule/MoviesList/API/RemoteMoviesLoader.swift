//
//  TMDBAPIConnector.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

typealias MoviesFetchCompletion = (TMDBResult) -> ()

protocol MoviesLoader {
    func getMovies(searchParams: FilterDataObject, completion:  @escaping MoviesFetchCompletion)
}

enum TMDBResult {
    case success([Movie])
    case failure(TMDBError)
}

enum TMDBError: Error {
    case CONNECTIVITY
    case MALFORMED_DATA
    case MALFORMED_URL
}

final class RemoteMoviesLoader{
    
    private let client: HTTPClient
    private var moviesContainer = MoviesContainer()
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    private func mapMovies(data: Data, response: HTTPURLResponse) -> TMDBResult {
        do {
            let moviesContainer = try MoviesListMapper.map(data)
            
            self.moviesContainer.update(page: MoviesContainer(currentPage: moviesContainer.currentPage,
                                                              totalPages: moviesContainer.totalPages,
                                                              totalResults: moviesContainer.totalResults,
                                                              movies: moviesContainer.movies))
            
            return .success(self.moviesContainer.movies)
        } catch {
            return .failure(.MALFORMED_DATA)
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
        
        if searchParams.shouldRefresh {
            self.moviesContainer = MoviesContainer()
        }
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
            case .failure:
                completion(.failure(.CONNECTIVITY))
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
