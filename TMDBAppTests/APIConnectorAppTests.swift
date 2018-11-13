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

    override func setUp() {
        guard let tmdbbURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=df2fffd5a0084a58bde8be99efd54ec0") else { return }
        stubRequest = StubRequest(method: .GET, url: tmdbbURL)
        stubResponse = StubResponse()
    }

    override func tearDown() {
        super.tearDown()
        Hippolyte.shared.stop()
    }
    
    func testMoviesResourceNotFound() {
        let path = Bundle(for: type(of: self)).path(forResource: "resourceNotFound", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let body = data
        stubResponse!.body = body as Data
        stubRequest!.response = stubResponse!
        Hippolyte.shared.add(stubbedRequest: stubRequest!)
        Hippolyte.shared.start()
        
        let searchObj = SearchObject()
        searchObj.filter = MovieFilter.POPULARITY
        let completionExpectation = expectation(description: "completionExpectation")

        TMDBAPIConnector.shared.getMovies(searchParams:searchObj, completion: { (movies:[Movie]?, error:Error?) in
            XCTAssert(movies == nil)
            XCTAssert(error != nil)
            completionExpectation.fulfill()

        })
        waitForExpectations(timeout: 0.5, handler: nil)

    }
    
    
    func testPopularMoviesSuccessResponse() {
      
        let path = Bundle(for: type(of: self)).path(forResource: "moviesSuccessResponse", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let body = data
        
        let completionExpectation = expectation(description: "completionExpectation")
        
        stubResponse!.body = body as Data
        stubRequest!.response = stubResponse!
        Hippolyte.shared.add(stubbedRequest: stubRequest!)
        Hippolyte.shared.start()
        
        let searchObj = SearchObject()
        searchObj.filter = MovieFilter.POPULARITY
        
        TMDBAPIConnector.shared.getMovies(searchParams:searchObj, completion: { (movies:[Movie]?, error:Error?) in
            XCTAssert(movies?.count == 20)
            XCTAssert(movies![0].title == "Venom")
            completionExpectation.fulfill()

            })
        waitForExpectations(timeout: 0.5, handler: nil)

    }

}
