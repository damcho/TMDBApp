//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation


class Movie {
    
    var title:String
    var movieId:Int
    var category:MovieFilter?
    var overview:String
    var popularity:Double
    var imageURLPath:String?
    var imageData:Data?

    
    init() {
        self.title = ""
        self.overview = ""
        self.movieId = 0
        self.popularity = 0
    }
    
    init(data:DecodedMovie) {
        self.title = data.title
        self.movieId = data.id
        self.overview = data.overview
        self.popularity = data.popularity
        self.imageURLPath = data.imageURL
        print(title)
    }
    
    func setCategory(category:MovieFilter) {
        self.category = category
        print(self.category)
    }
    
    func getImage(completion: @escaping (Data) -> ()){
        
        let handler = { (data:Data?) -> () in
            self.imageData = data
            if data != nil {
                TMDBCoreDataConnector.shared.save(imageData: self.imageData!, with: self.imageURLPath!, and: nil)
                completion(data!)
            }
        }
        
        if self.imageData != nil {
            handler(self.imageData!)
        } else {
            MovieManager.getImage(path: self.imageURLPath!, completion: handler)
        }
    }}
