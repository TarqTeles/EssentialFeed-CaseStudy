//
//  NullStore.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 12/05/23.
//

import Foundation
import EssentialFeed

final class NullStore: FeedStore {
    func deleteCachedFeed() throws {}
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date) throws {}
    
    func retrieve() throws -> CachedFeed? { return nil }
}

extension NullStore: FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws {}
    
    func retrieve(dataForURL url: URL) throws -> Data? { .none }
    
}
                    
