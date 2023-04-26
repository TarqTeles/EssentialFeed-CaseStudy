//
//  ImageCommentsMapper.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 25/04/23.
//

import Foundation

public final class ImageCommentsMapper {
    private struct root: Decodable {
        private let items: [Item]
        
        private struct Item: Decodable {
            let id: UUID
            let message: String
            let created_at: Date
            let author: Author
        }
        
        private struct Author: Decodable {
            let username: String
        }
        
        var comments: [ImageComment] {
            items.map {
                ImageComment(id: $0.id, message: $0.message, createdAt: $0.created_at, username: $0.author.username)
            }
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [ImageComment] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard isOK(response.statusCode), let root = try? decoder.decode(root.self, from: data) else {
            throw RemoteLoader<[ImageComment]>.Error.invalidData
        }
        
        return root.comments
    }
    
    private static func isOK(_ statusCode: Int) -> Bool {
        return (200...299).contains(statusCode)
    }
}
