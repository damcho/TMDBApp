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
        let movie = Movie()
        XCTAssertEqual(movie.title, "")
        XCTAssertEqual(movie.popularity, 0)
        XCTAssertEqual(movie.voteAverage, 0)
        XCTAssertEqual(movie.movieId, 0)
        XCTAssertEqual(movie.imageData, nil)
        XCTAssertEqual(movie.imageURLPath, nil)
        XCTAssertEqual(movie.overview, "")
        XCTAssertEqual(movie.category, nil)

    }

}
