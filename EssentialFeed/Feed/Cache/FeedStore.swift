//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 23/10/22.
//

import Foundation


public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    
    typealias InsertionResult = Result<Void, Error>
    typealias InsertionCompletion = (InsertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedFeed?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void

    /// This method runs synchronously and may block the main thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    func deleteCachedFeed() throws

    /// This method runs synchronously and may block the main thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    
    /// This method runs synchronously and may block the main thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    func retrieve() throws -> CachedFeed?
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    @available(*, deprecated)
    func deleteCachedFeed(completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    @available(*, deprecated)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    @available(*, deprecated)
    func retrieve(completion: @escaping RetrievalCompletion)
}

extension FeedStore {
    public func deleteCachedFeed() throws {
        let group = DispatchGroup()
        group.enter()
        var result: DeletionResult!
        deleteCachedFeed(completion: {
            result = $0
            group.leave()
        })
        group.wait()
        if case let .failure(error) = result {
            throw error
        }
    }

    public func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        let group = DispatchGroup()
        group.enter()
        var result: InsertionResult!
        insert(feed, timestamp: timestamp) {
            result = $0
            group.leave()
        }
        group.wait()
        if case let .failure(error) = result {
            throw error
        }
    }
    
    public func retrieve() throws -> CachedFeed? {
        let group = DispatchGroup()
        group.enter()
        var result: RetrievalResult!
        retrieve(completion: {
            result = $0
            group.leave()
        })
        group.wait()
        switch result {
            case let .success(cache):
                print("success with \(String(describing: cache?.feed.count)) items")
                return cache
            case let .failure(error):
                throw error
            case .none:
                return .none
        }
    }
}
