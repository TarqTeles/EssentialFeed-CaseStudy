//
//  ImageCommentEndpoint.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 09/05/23.
//

import Foundation

public enum ImageCommentEndpoint {
    case get(UUID)
    
    public func url(baseURL: URL) -> URL {
        switch self {
            case let .get(id):
                return baseURL.appending(path: "v1/image/\(id.uuidString)/comments")
        }
    }
}
