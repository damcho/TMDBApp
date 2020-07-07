//
//  TMDBAPIConnector.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import SystemConfiguration
import Alamofire


enum TMDBError: Error {
    case API_ERROR(reason:String)
    case NOT_FOUND
    case MALFORMED_DATA
}

enum IMDBError: Error {
    case invalidData
    case connection
}

struct AFHTTPError: Codable {
    var status_message: String?
}

enum HTTPError: Error {
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

enum HTTPClientResult {
    case success(Data)
    case failure(HTTPError)
}

class TMDBAPIConnector: DataConnector{
    
    func getMovies(searchParams: SearchObject, completion:  @escaping (IMDBResult) -> ()) {
        guard let url = createURL(searchPath: searchParams.searchMoviesUrlPath() , queryItems:searchParams.searchMoviesQueryItems() ) else {
            return
        }
        
        let completionHandler: (HTTPClientResult) -> Void = { (result) in
            switch result {
            case .success(let data):
                guard let rootResult = try? JSONDecoder().decode(RootResult.self, from: data) else {
                    completion(.failure(.MALFORMED_DATA))
                    return
                }
                completion(.success(MovieContainer(currentPage: rootResult.currentPage, totalPages: rootResult.totalPages, totalResults: rootResult.totalResults, movies: rootResult.movies)))
            case .failure(let error):
                completion(.failure(.API_ERROR(reason: error.localizedDescription)))
            }
        }
        
        self.performRequest(url: url, completion: completionHandler)
    }
    
    func getMovieDetail(searchParams: SearchObject, completion:  @escaping (MovieDetailResult) -> ()) {
        guard let url = createURL(searchPath: searchParams.movieDetailUrlPath(), queryItems:searchParams.movieDetailQueryItems() ) else {
            return
        }
        
        let completionHandler = { (result: HTTPClientResult) in
            switch result {
            case .success(let data):
                guard let codableMovie = try? JSONDecoder().decode(CodableMovie.self, from: data) else {
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
        
        self.performRequest(url: url, completion: completionHandler)
    }
    
    func loadImage(from imagePath: String, completion:  @escaping (Data?) -> ()) {
        let completionHandler = { (result: HTTPClientResult ) in
            switch result {
            case .success(let data):
                completion(data)
            default:
                completion(nil)
            }
        }
        guard let imageURL = URL(string: imageBaseURL + imagePath) else {
            completion(nil)
            return
        }
        self.performRequest(url: imageURL, completion: completionHandler)
    }
    
    
    static let shared = TMDBAPIConnector()
    private let host = "api.themoviedb.org"
    private let scheme = "https"
    
    private let APIKey:String = "df2fffd5a0084a58bde8be99efd54ec0"
    private let imageBaseURL:String = "https://image.tmdb.org/t/p/w300"
    
    func performRequest(url: URL, completion: @escaping (HTTPClientResult) -> ()) {
        AF.request(url, method: .get)
            .validate()
            .responseData{ response in
                switch response.result {
                case .success:
                    completion( .success(response.data!))
                case.failure:
                    guard let data = response.data, let jsonError = try? JSONDecoder().decode(AFHTTPError.self, from: data) else {
                        completion(.failure(.unknownError))
                        return
                    }
                    completion(.failure(.customError(jsonError)))
                }
        }
    }
    
    func createURL(searchPath:String, queryItems:[URLQueryItem]?) -> URL? {
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
    
    func createImageURL(urlString:String) -> URL? {
        if let urlComponents = URLComponents(string: imageBaseURL + urlString) {
            guard let url = urlComponents.url else { return nil }
            return url
        }
        return nil
    }
}



public class Reachability {
    
    static let reachabilityManager = Alamofire.NetworkReachabilityManager (host: "www.apple.com")
    static func listenForReachability() {
        reachabilityManager!.startListening { (listener: NetworkReachabilityManager.NetworkReachabilityStatus) in
            // do something on status change
        }
    }
    
    static func isConnectedToNetwork() -> Bool{
        return reachabilityManager!.isReachable
    }
}

