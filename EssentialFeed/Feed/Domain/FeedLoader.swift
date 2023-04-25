//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 05/10/22.
//

import Foundation


public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    
    func load(completion: @escaping (FeedLoader.Result) -> Void)
}
