//
//  FeedLoaderCacheDecorator.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 17/03/23.
//

import EssentialFeed

public final class FeedLoaderCacheDecorator: FeedLoader {
    private let decoratee: FeedLoader
    private let cache: FeedCache
    
    public init(decoratee: FeedLoader, cache: FeedCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    public func load(completion: @escaping (FeedLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            completion(result.map { feed in
                self?.saveIgnoringResult(feed: feed)
                return feed
            })
        }
    }
    
    private func saveIgnoringResult(feed: [FeedImage]) {
        cache.save(feed: feed) { _ in }
    }
}
