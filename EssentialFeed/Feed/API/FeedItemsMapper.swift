//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 10/10/22.
//

import Foundation

public final class FeedItemsMapper {
    private struct root: Decodable {
        let items: [RemoteFeedItem]
        
        var images: [FeedImage] {
            items.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.image) }
        }

    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [FeedImage] {
        guard response.isOK, let root = try? JSONDecoder().decode(root.self, from: data) else {
            throw Error.invalidData
        }
        
        return root.images
    }
}
