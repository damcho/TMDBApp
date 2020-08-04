//
//  AlamoFireHTTPClient.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import Alamofire

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(HTTPError)
}

public struct AFHTTPError: Codable {
    var status_message: String?
}

public enum HTTPError: Error {
    case notFound
    case unknownError
    case connectionError
    case customError(AFHTTPError)
}

public protocol HTTPClient {
    @discardableResult
    func request(url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask
}

public protocol HTTPClientTask {
    func cancel()
}

private class AFHTTPTask: HTTPClientTask {
    private let task: DataRequest
    
    init(task: DataRequest) {
        self.task = task
    }
    
    func cancel() {
        task.cancel()
    }
}

public class AlamoFireHttpClient: HTTPClient {
    
    public init() {}
    
    public func request(url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask{
        return AFHTTPTask(task: AF.request(url, method: .get)
            .validate()
            .responseData{ AFResult in
                switch AFResult.result {
                case .success:
                    completion( .success(AFResult.data!, AFResult.response!))
                case.failure:
                    guard let data = AFResult.data, let jsonError = try? JSONDecoder().decode(AFHTTPError.self, from: data) else {
                        completion(.failure(.unknownError))
                        return
                    }
                    completion(.failure(.customError(jsonError)))
                }
        })
    }
}
