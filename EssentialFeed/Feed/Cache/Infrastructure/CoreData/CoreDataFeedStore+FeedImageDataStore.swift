//
//  CoreDataFeedStore+FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 10/03/23.
//

import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    public func insert(_ data: Data, for url: URL) throws {
        try performSync { context in
            context.userInfo[url] = data
            return Result {
                try ManagedFeedImage.first(with: url, in: context)
                    .map { $0.data = data }
                    .map(context.save)
            }
        }
    }
    
    public func retrieve(dataForURL url: URL) throws -> Data? {
        try performSync { context in
            return Result {
                if let data = context.userInfo[url] as? Data {
                    return data
                } else {
                    return try ManagedFeedImage.data(with: url, in: context)
                }
            }
        }
    }
}
