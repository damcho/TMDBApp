//
//  ImageDataLoader.swift
//  TMDBApp
//
//  Created by Damian Modernell on 7/31/20.
//  Copyright © 2020 Damian Modernell. All rights reserved.
//

import Foundation

public enum ImageLoadingResult {
    case success(Data)
    case failure(Error)
}

public protocol CancelableImageTask {
    func cancel()
}


public final class ImageDataLoader {
    
    let client: HTTPClient
    
    public init(client: HTTPClient) {
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
    
    public func loadImage(from url: URL, completion: @escaping (ImageLoadingResult) -> Void) -> CancelableImageTask{
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