//
//  Video.swift
//  TMDBApp
//
//  Created by Damian Modernell on 09/01/2019.
//  Copyright © 2019 Damian Modernell. All rights reserved.
//

import Foundation

class Video {
    
    let id:String
    let title:String
    
    init(data:Dictionary<String, Any>) {
        id = data["id"]! as! String
        title = data["name"]! as! String
    }
}
