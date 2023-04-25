//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 17/03/23.
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
