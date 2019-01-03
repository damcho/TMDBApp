//
//  MovieModuleProtocols.swift
//  TMDBApp
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import Foundation
import UIKit
typealias QueryResut = ([Movie]?, Error?) -> ()


protocol DataConnector {
    
    func getMovies(searchParams: SearchObject, completion: @escaping QueryResut )
    func loadImage(from url: String, completion: @escaping (UIImage?) -> ())
    func saveImage(imageData: Data, with fileName: String, and imageName: String?)

}
