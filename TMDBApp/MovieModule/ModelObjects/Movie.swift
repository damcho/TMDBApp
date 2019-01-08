//
//  Movie.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit

class Movie : Equatable, Hashable{
    
    
    var title:String
    var movieId:Int
    var category:MovieFilter?
    var overview:String
    var popularity:Double
    var voteAverage:Double
    var imageURLPath:String?

    init() {
        self.title = ""
        self.overview = ""
        self.movieId = 0
        self.popularity = 0
        self.voteAverage = 0
    }
    
    init?(data:Dictionary<String, Any>) {
        guard let title = data["title"] as? String else {
            return nil
        }
        self.title = title
        
        guard let overview = data["overview"] as? String else {
            return nil
        }
        self.overview = overview

        guard let nobieId = data["id"] as? Int else {
            return nil
        }
        self.movieId = nobieId
        
        guard let popularity = data["popularity"] as? Double else {
            return nil
        }
        self.popularity = popularity

        guard let voteAverage = data["vote_average"] as? Double else {
            return nil
        }
        self.voteAverage = voteAverage
        
        guard let imageUrl = data["poster_path"] as? String else {
            return nil
        }
        self.imageURLPath = imageUrl
    }
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.movieId == rhs.movieId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.movieId)
    }
    
    func setCategory(category:MovieFilter) {
        self.category = category
    }
    
    
    
    func getImage(completion: @escaping (UIImage?) -> ()){
        MovieManager.shared.getImage(path: self.imageURLPath!, completion: completion)
    }
}
