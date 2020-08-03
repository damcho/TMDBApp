//
//  AlamoFireHTTPClient.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation
import Alamofire

public protocol HTTPClient {
    @discardableResult
    func request(url: URL, completion: @escaping (HTTPClientResult) -> Void) -> HTTPClientTask
}

public protocol HTTPClientTask {
    func cancel()
}

class AFHTTPTask: HTTPClientTask {
    let task: DataRequest
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
