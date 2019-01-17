//
//  APIConnectorAppTests.swift
//  TMDBAppTests
//
//  Created by Damian Modernell on 12/11/2018.
//  Copyright © 2018 Damian Modernell. All rights reserved.
//

import XCTest
import Hippolyte

@testable import TMDBApp

class APIConnectorAppTests: XCTestCase {

    var stubResponse:StubResponse?
    var stubRequest:StubRequest?
    var searchObject:SearchObject?
    
    override func setUp() {
        guard let tmdbbURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=df2fffd5a0084a58bde8be99efd54ec0&page=1") else { return }
        stubRequest = StubRequest(method: .GET, url: tmdbbURL)
        stubResponse = StubResponse()
        searchObject = SearchObject()
        searchObject!.category = MovieFilterType.POPULARITY
    }

    override func tearDown() {
        super.tearDown()
        Hippolyte.shared.stop()
    }
    
    func testMoviesResourceNotFound() {
        let path = Bundle(for: type(of: self)).path(forResource: "resourceNotFound", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        stubResponse!.body = data as Data
        stubResponse!.statusCode = 404
        stubRequest!.response = stubResponse!
        Hippolyte.shared.add(stubbedRequest: stubRequest!)
        Hippolyte.shared.start()

        let completionExpectation = expectation(description: "completionExpectation")

        TMDBAPIConnector.shared.getMovies(searchParams:searchObject!, completion: { (movies:MoviesContainer?, error:Error?) in
            XCTAssert(movies == nil)
            XCTAssert(error != nil)
            let error = error! as NSError
            XCTAssert(error.code == 34)

            completionExpectation.fulfill()

        })
        waitForExpectations(timeout: 0.5, handler: nil)

    }
    
    
    func testPopularMoviesSuccessResponse() {
      
        let path = Bundle(for: type(of: self)).path(forResource: "moviesSuccessResponse", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        
        let completionExpectation = expectation(description: "completionExpectation")

        stubResponse!.body = data as Data
        stubResponse!.statusCode = 200
        stubRequest!.response = stubResponse!
        Hippolyte.shared.add(stubbedRequest: stubRequest!)
        Hippolyte.shared.start()
        
        TMDBAPIConnector.shared.getMovies(searchParams:searchObject!, completion: { (movieContainer:MoviesContainer?, error:Error?) in
            XCTAssert(movieContainer?.movies.count == 20)
            XCTAssert(movieContainer?.movies[0].title == "Venom")
            completionExpectation.fulfill()

            })
        waitForExpectations(timeout: 0.5, handler: nil)

    }

}
