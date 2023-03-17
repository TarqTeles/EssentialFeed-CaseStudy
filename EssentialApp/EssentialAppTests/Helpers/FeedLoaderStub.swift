//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 17/03/23.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    let result: FeedLoader.Result
    
    init(received: FeedLoader.Result) {
        self.result = received
    }
    
    func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) {
        completion(result)
    }
}

