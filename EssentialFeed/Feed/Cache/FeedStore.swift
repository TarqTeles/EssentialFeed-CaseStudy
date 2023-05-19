//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 23/10/22.
//

import Foundation


public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    /// This method runs synchronously and may block the main thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    func deleteCachedFeed() throws

    /// This method runs synchronously and may block the main thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws
    
    /// This method runs synchronously and may block the main thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    func retrieve() throws -> CachedFeed?
}
