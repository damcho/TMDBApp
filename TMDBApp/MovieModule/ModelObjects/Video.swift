//
//  Video.swift
//  TMDBApp
//
//  Created by Damian Modernell on 09/01/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

final class Video: Codable {
    
    let id:String
    let title:String
    
    enum CodingKeys: String, CodingKey {
         case id = "key"
         case title = "name"
     }
}
