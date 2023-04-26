//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 05/10/22.
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(
            url: url,
            client: client,
            mapper: FeedItemsMapper.map
        )
    }
}
