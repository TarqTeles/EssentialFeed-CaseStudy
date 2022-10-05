//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 05/10/22.
//

import Foundation

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error in
            completion(.connectivity)
        }
    }
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error) -> Void)
}
