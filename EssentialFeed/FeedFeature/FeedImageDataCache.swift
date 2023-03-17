//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 17/03/23.
//

import Foundation

public protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Swift.Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}
