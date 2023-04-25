//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 23/10/22.
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
