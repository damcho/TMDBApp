//
//  MovieImageLoaderTests.swift
//  TMDBAppTests
//
//  Created by Damian Modernell on 7/30/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import XCTest
import TMDBApp

enum ImageLoadingResult {
    case success(Data)
    case failure(Error)
}

protocol CancelableImageTask {
    func cancel()
}


class ImageDataLoader {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    private class ImageLoaderTask: CancelableImageTask {
        var completion: ((ImageLoadingResult) -> Void)?
        var wrappedTask: HTTPClientTask?
        
        init(completion: @escaping (ImageLoadingResult) -> Void) {
            self.completion = completion
        }
        
        func completeWithResult(_ result: ImageLoadingResult){
            completion?(result)
        }
        func cancel() {
            self.completion = nil
            self.wrappedTask?.cancel()
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (ImageLoadingResult) -> Void) -> CancelableImageTask{
        let task = ImageLoaderTask(completion: completion)
        task.wrappedTask = client.request(url: url, completion: {[weak self] (result) in
            guard self != nil else { return }
            
            switch result {
            case .failure(let error):
                task.completeWithResult(.failure(error))
            case .success(let data, let httpresponse):
                guard httpresponse.statusCode == 200 else {
                    task.completeWithResult(.failure(NSError(domain: "response error", code: 1)))
                    return
                }
                task.completeWithResult(.success(data))
            }
        })
        return task
    }
}

class MovieImageLoaderTests: XCTestCase {
    
    
    func testFailureLoadingImage() {
        let (sut, client) = makeSUT()
        let failureImageURL = URL(string: "www.someurl.com")!
        let someError = NSError(domain: "error", code:1)
        
        expect(.failure(someError), for: sut, from: failureImageURL, when: {
            client.completeWithError()
        })
    }
    
    func testImageReceivedSuccessfully() {
        let (sut, client) = makeSUT()
        let url = URL(string: "www.someurl.com")!
        let someData = "some data".data(using: .utf8)!
        
        expect(.success(someData), for: sut, from: url, when: {
            client.completeWithSuccess(data: someData)
        })
    }
    
    func testDoesNotReturnsResultOnImageCancelled() {
        let (sut, client) = makeSUT()
        let url = URL(string: "www.someurl.com")!
        let someData = "some data".data(using: .utf8)!
        var receivedResults: [ImageLoadingResult] = []
        
        let task = sut.loadImage(from: url, completion: {result in
            receivedResults.append(result)
        })
        
        task.cancel()
        
        client.completeWithSuccess(data: someData)
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    
    // Helpers
    private func expect(_ expectedResult: ImageLoadingResult, for sut: ImageDataLoader, from url: URL, when action: () -> Void) {
        let expect = expectation(description: "expected result")
        
        _ = sut.loadImage(from: url, completion: { (result) in
            switch (result, expectedResult)  {
            case (.failure, .failure):
                XCTAssertTrue(true)
            case (.success(let data), .success(let expectedData)):
                XCTAssertEqual(data, expectedData)
            default:
                XCTFail()
            }
            expect.fulfill()
        })
        
        action()
        
        wait(for: [expect], timeout: 1.0)
    }
    
    private func makeSUT() -> (ImageDataLoader, HTTPClientSpy) {
        let clientSpy = HTTPClientSpy()
        return (ImageDataLoader(client: clientSpy), clientSpy)
    }
    
}

private struct Task: HTTPClientTask{
    func cancel() {
        
    }
}

class HTTPClientSpy: HTTPClient {
    var completions: [(HTTPClientResult) -> Void] = []
    func request(url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask{
        completions.append(completion)
        return Task()
    }
    
    func completeWithError() {
        if completions.count > 0 {
            completions[0](.failure(.unknownError))
        }
    }
    
    func completeWithSuccess(data: Data) {
        let response = HTTPURLResponse(url: URL(string: "www.someurl.com")!, statusCode: 200, httpVersion: "2", headerFields: [:])
        if completions.count > 0 {
            completions[0](.success(data, response!))
        }
    }
    
}
