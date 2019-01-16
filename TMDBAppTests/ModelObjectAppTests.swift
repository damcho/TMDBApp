//
//  TMDBAppTests.swift
//  TMDBAppTests
//
//  Created by Damian Modernell on 07/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import XCTest
@testable import TMDBApp

class ModelObjectAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMovieModelCreation() {
        
        let path = Bundle(for: type(of: self)).path(forResource: "movieMock", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        
        guard let movieDictionary = try? JSONSerialization.jsonObject(with: data as Data, options: []) as! Dictionary<String, Any> else {
            return
        }
        
        let movie = Movie(data:movieDictionary)
        XCTAssertEqual(movie!.title, "The Godfather")
        XCTAssertEqual(movie!.popularity, 26.798)
        XCTAssertEqual(movie!.voteAverage, 8.6)
        XCTAssertEqual(movie!.movieId, 238)
        XCTAssertEqual(movie!.videos?.count,  2)
        XCTAssertTrue(movie!.overview != "")
        
        let movie2 = Movie(data:movieDictionary)
        XCTAssertEqual(movie, movie2)
    }

}
