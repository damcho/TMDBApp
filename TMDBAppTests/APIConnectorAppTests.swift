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
    var searchObject:filterDataObject?
    
    override func setUp() {
        guard let tmdbbURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=df2fffd5a0084a58bde8be99efd54ec0&page=1") else { return }
        stubRequest = StubRequest(method: .GET, url: tmdbbURL)
        stubResponse = StubResponse()
        searchObject = filterDataObject()
        searchObject!.category = MovieFilterType.POPULARITY
    }

    override func tearDown() {
        super.tearDown()
        Hippolyte.shared.stop()
    }

    
  

}
