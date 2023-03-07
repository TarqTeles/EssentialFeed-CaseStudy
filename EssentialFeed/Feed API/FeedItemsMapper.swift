//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 10/10/22.
//

import Foundation

final class FeedItemsMapper {
    private struct root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(root.self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        
        return root.items
    }
}
