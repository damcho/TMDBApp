//
//  MovieImageLoaderTests.swift
//  TMDBAppTests
//
//  Created by Damian Modernell on 7/30/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import TMDBApp

class ImageDataLoader {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImage(from url: URL, completion: (Error) -> Void) {
        completion(NSError(domain: "some error", code: 1))
    }
}

class MovieImageLoaderTests: XCTestCase {


    func testFailureLoadingImage() {
        let sut = ImageDataLoader(client: AlamoFireHttpClient())
        let failureImageURL = URL(string: "www.someurl.com")!
        let expect = expectation(description: "image error retrieved")
        
        sut.loadImage(from: failureImageURL, completion: { (result) in
            expect.fulfill()
            })
        
        wait(for: [expect], timeout: 1.0)
        
    }

}
