//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 09/05/23.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        baseURL.appending(path: "v1/feed")
    }
}
