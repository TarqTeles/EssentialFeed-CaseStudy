//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 17/03/23.
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}
