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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        super.tearDown()
        Hippolyte.shared.stop()
    }
    
    func testMoviesResourceNotFound() {
        guard let tmdbbURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=df2fffd5a0084a58bde8be99efd54ec0") else { return }
        var stub = StubRequest(method: .GET, url: tmdbbURL)
        var response = StubResponse()
        let path = Bundle(for: type(of: self)).path(forResource: "resourceNotFound", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let body = data
        response.body = body as Data
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        
        let searchObj = SearchObject()
        searchObj.filter = MovieFilter.POPULARITY
        TMDBAPIConnector.shared.getMovies(searchParams:searchObj, completion: { (movies:[Movie]?, error:Error?) in
            XCTAssert(movies == nil)
            XCTAssert(error != nil)
        })
    }
    
    
    func testPopularMoviesSuccessResponse() {
        guard let tmdbbURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=df2fffd5a0084a58bde8be99efd54ec0") else { return }
        var stub = StubRequest(method: .GET, url: tmdbbURL)
        var response = StubResponse()
        let path = Bundle(for: type(of: self)).path(forResource: "moviesSuccessResponse", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let body = data
        response.body = body as Data
        stub.response = response
        Hippolyte.shared.add(stubbedRequest: stub)
        Hippolyte.shared.start()
        
        let searchObj = SearchObject()
        searchObj.filter = MovieFilter.POPULARITY
        
        TMDBAPIConnector.shared.getMovies(searchParams:searchObj, completion: { (movies:[Movie]?, error:Error?) in
            XCTAssert(movies?.count == 20)
            XCTAssert(movies![0].title == "Venom")

            })
    }

}
