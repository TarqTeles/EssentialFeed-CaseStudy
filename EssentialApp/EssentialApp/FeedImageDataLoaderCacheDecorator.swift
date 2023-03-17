//
//  FeedImageDataLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 17/03/23.
//

import Foundation
import EssentialFeed

public final class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    private class TaskWrapper: FeedImageDataLoaderTask {
        var wrapped: FeedImageDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    private let decoratee: FeedImageDataLoader
    private let cache: FeedImageDataCache
    
    public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> EssentialFeed.FeedImageDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = decoratee.loadImageData(from: url) { [weak self] result in
            completion(result.map { data in
                self?.saveIgnoringResult(data, for: url)
                return data
            })
        }
        return task
    }
}

private extension FeedImageDataLoaderCacheDecorator {
    func saveIgnoringResult(_ data: Data, for url: URL) {
        cache.save(data, for: url) { _ in }
    }
}
