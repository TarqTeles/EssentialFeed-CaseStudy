//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 23/10/22.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalFeedLoader: FeedCache {
    public func save(feed: [FeedImage]) throws {
        do {
            try store.deleteCachedFeed()
            try store.insert(feed.toLocal(), timestamp: currentDate())
        } catch {
            throw error
        }
    }
}

extension LocalFeedLoader {
    public func load() throws -> CachedFeed?  {
        do {
            if let cache = try store.retrieve(), FeedCachePolicy.validate(cache.timestamp, against: self.currentDate()) {
                return cache
            } else {
                return nil
            }
        } catch {
            throw error
        }
    }
}

extension LocalFeedLoader {
    public func validateCache() throws {
        var cache: CachedFeed?
        var validationError: Error?
        do {
            cache = try store.retrieve()
        } catch {
            validationError = error
        }
        
        if !isValidCache(cache) || validationError != nil {
            do {
                return try store.deleteCachedFeed()
            } catch {
                validationError = error
            }
        }
        
        if let error = validationError {
            throw error
        }
    }
    
    private func isValidCache(_ cache: CachedFeed?) -> Bool {
        guard let foundCache = cache else { return true }
                
        return FeedCachePolicy.validate(foundCache.timestamp, against: self.currentDate())
    }
}

public extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}

public extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        return map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
