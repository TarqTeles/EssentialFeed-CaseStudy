//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 17/03/23.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(feed: [FeedImage]) throws
    
    @available(*, deprecated)
    func save(feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}

extension FeedCache {
    public func save(feed: [FeedImage]) throws {
        let group = DispatchGroup()
        group.enter()
        var result: SaveResult!
        save(feed: feed) {
            result = $0
            group.leave()
        }
        group.wait()
        if case let .failure(error) = result {
            throw error
        }
    }
}
