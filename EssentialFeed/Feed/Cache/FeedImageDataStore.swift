//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 08/03/23.
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
