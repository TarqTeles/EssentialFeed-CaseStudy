//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 08/03/23.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
