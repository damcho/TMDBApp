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

let APIKey:String = "df2fffd5a0084a58bde8be99efd54ec0"

let imageBaseURL:String = "https://image.tmdb.org/t/p/w500"
var isFetchingMovies = false

//let APIReadAccessToken:String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZjJmZmZkNWEwMDg0YTU4YmRlOGJlOTllZmQ1NGVjMCIsInN1YiI6IjViZTJkYWRkMGUwYTI2MTRiNjAxMmNhZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dBKb9rKru20L3B5E5XM06xsWNMLED2fZynIZd_pH9-8"

class TMDBAPIConnector :DataConnector{
    
    
    static let shared = TMDBAPIConnector()
    
    let baseURL = "https://api.themoviedb.org/3"
    let movie = "/movie"
    
    func performRequest(url: URL, completion: @escaping (Data?, Error?) -> ()){
        AF.request(url, method: .get)
            .validate()
            .responseData{ response in
                guard response.result.isSuccess else {
                    
                    if let data = response.data , let jsonError = try? JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary  {
                        let error = NSError(domain: "", code:jsonError["status_code"] as! Int, userInfo: [NSLocalizedDescriptionKey:jsonError["status_message"]!])
                        completion(nil, error)
                    } else {
                        completion(nil, response.error)
                    }
                    return
                }
                completion(response.data, nil)
        }
    }
    
    func createMoviesSearchUrl(searchParams:SearchObject) -> URL? {
        if var urlComponents = URLComponents(string: baseURL + movie + searchParams.moviesSearchUrl()) {
            urlComponents.query = "api_key=\(APIKey)&page=\(searchParams.page)"
            guard let url = urlComponents.url else { return nil }
            return url
        }
        return nil
    }
    
    func getMovies(searchParams: SearchObject, completion: @escaping (moviesContainerCompletionHandler)) -> () {
        guard let url = createMoviesSearchUrl(searchParams: searchParams) else {
            return
        }
        
        let completionHandler = { (data:Data?, error:Error?) in
            isFetchingMovies = false
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                    guard let moviesContainer = MoviesContainer(data:json) else {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Malformed data received from getMovies service"]))
                        return
                    }
                    completion(moviesContainer, nil)
                } catch  {
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Malformed data received from getMovies service"]))
                }
            } else {
                completion(nil, error)
            }
        }
        
        if !isFetchingMovies {
            isFetchingMovies = true
            self.performRequest(url: url, completion: completionHandler)
        }
    }
    
    func createMovieDetailURL(searchParams:SearchObject) -> URL? {
        if var urlComponents = URLComponents(string: baseURL + movie + searchParams.movieDetailUrl()) {
            urlComponents.query = "api_key=\(APIKey)&append_to_response=videos"
            guard let url = urlComponents.url else { return nil }
            return url
        }
        return nil
    }
    
    func getMovieDetail(searchParams: SearchObject, completion: @escaping movieDetailCompletionHandler) {
        guard let url = createMovieDetailURL(searchParams: searchParams) else {
            return
        }
        
        let completionHandler = { (data:Data?, error:Error?) in
            if error == nil {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! Dictionary<String, Any>
                    guard let movie = Movie(data: json) else {
                        completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Malformed data received from fetchAllRooms service"]))
                        return
                    }
                    completion(movie, nil)
                } catch  {
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Malformed data received from getMovies service"]))
                }
            } else {
                completion(nil, error)
            }
        }
        
        self.performRequest(url: url, completion: completionHandler)
    }
    
    func createImageURL(urlString:String) -> URL? {
        if let urlComponents = URLComponents(string: imageBaseURL + urlString) {
            guard let url = urlComponents.url else { return nil }
            return url
        }
        return nil
    }
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = createImageURL(urlString: url) else {
            return
        }
        let completionHandler = { (data:Data?, error:Error?) in
            if error == nil {
                let image = UIImage(data:data!)
                completion(image)
            }
        }
        self.performRequest(url: url, completion: completionHandler)
    }
}



public class Reachability {
    
    static let reachabilityManager = Alamofire.NetworkReachabilityManager (host: "www.apple.com")
    static func listenForReachability() {
        reachabilityManager!.startListening()
    }
    
    static func isConnectedToNetwork() -> Bool{
        return reachabilityManager!.isReachable
    }
}

