//
//  TMDBAPIConnector.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation

let APIKey:String = "df2fffd5a0084a58bde8be99efd54ec0"
let APIReadAccessToken:String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZjJmZmZkNWEwMDg0YTU4YmRlOGJlOTllZmQ1NGVjMCIsInN1YiI6IjViZTJkYWRkMGUwYTI2MTRiNjAxMmNhZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dBKb9rKru20L3B5E5XM06xsWNMLED2fZynIZd_pH9-8"


class TMDBAPIConnector :DataConnector{
    
    
    static let shared = TMDBAPIConnector()
    
    let baseURL = "https://api.themoviedb.org/3"
    let discover = "/discover"
    let movie = "/movie"
    let defaultSession:URLSession
    var dataTask: URLSessionDataTask?
    
    init() {
        defaultSession = URLSession(configuration: .default)
    }
    
    func getMovies(searchParams: SearchObject, completion: @escaping ([Movie]?, Error?) -> ()) {
        
        if var urlComponents = URLComponents(string: baseURL + discover + movie) {
            urlComponents.query = "api_key=\(APIKey)" + searchParams.urlString()
            
            print(urlComponents)
            guard let url = urlComponents.url else { return }
            self.requestMedia(url: url, completionHandler: completion)
        }
    }
    
    func getMovieDetali(searchParams: SearchObject, completion: @escaping ([Movie]?, Error?) -> ()) {
        if var urlComponents = URLComponents(string: baseURL + movie) {
            //        urlComponents.query = searchParams.urlString()
            
            print(urlComponents)
            guard let url = urlComponents.url else { return }
            self.requestMedia(url: url, completionHandler: completion)
        }
    }
    
    
    
    func requestMedia(url: URL, completionHandler: @escaping ([Movie]?, Error?) -> ()){
        dataTask = defaultSession.dataTask(with: url) { data, response, error in
            defer {
                self.dataTask = nil
            }
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let movies:[Movie] = try MovieObjectDecoder.decode(data: data)
                    DispatchQueue.main.async {
                        completionHandler(movies, nil )
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completionHandler(nil, error )
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
}
