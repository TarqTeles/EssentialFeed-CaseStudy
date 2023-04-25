//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 25/04/23.
//

import Foundation

final class ImageCommentsMapper {
    private struct root: Decodable {
        let items: [RemoteFeedItem]
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteFeedItem] {
        guard response.isOK, let root = try? JSONDecoder().decode(root.self, from: data) else {
            throw RemoteImageCommentsLoader.Error.invalidData
        }
        
        return root.items
    }
}
