//
//  TMDBAPIConnector.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import SystemConfiguration

let APIKey:String = "df2fffd5a0084a58bde8be99efd54ec0"

let imageBaseURL:String = "https://image.tmdb.org/t/p/w500"

//let APIReadAccessToken:String = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkZjJmZmZkNWEwMDg0YTU4YmRlOGJlOTllZmQ1NGVjMCIsInN1YiI6IjViZTJkYWRkMGUwYTI2MTRiNjAxMmNhZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.dBKb9rKru20L3B5E5XM06xsWNMLED2fZynIZd_pH9-8"


class TMDBAPIConnector :DataConnector{
    
    
    static let shared = TMDBAPIConnector()
    
    let baseURL = "https://api.themoviedb.org/3"
    let movie = "/movie"
    let defaultSession:URLSession
    var dataTask: URLSessionDataTask?
    var searchParams: SearchObject?

    
    init() {
        defaultSession = URLSession(configuration: .default)
    }
    
    func getMovies(searchParams: SearchObject, completion: @escaping ([Movie]?, Error?) -> ()) {
        self.searchParams = searchParams
        if var urlComponents = URLComponents(string: baseURL + movie + searchParams.urlString()) {
            urlComponents.query = "api_key=\(APIKey)"
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
                    for movie in movies {
                        movie.setCategory(category:self.searchParams!.filter)
                    }
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
    
    static func downloadImage(from url: String, completion: @escaping (Data) -> ()) {
        if let urlComponents = URLComponents(string: imageBaseURL + url) {

            guard let url = urlComponents.url else { return }
            let completionHandler = { (data:Data?, response:URLResponse?, error:Error?) in
                
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async() {
                    completion(data)
                }
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
        }
    }
}


public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == false {
            return false
        }
        
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired
        
        return isReachable && !needsConnection
        
    }
}
