//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 17/03/23.
//

import Foundation

public protocol FeedCache {
    func save(feed: [FeedImage]) throws
}
