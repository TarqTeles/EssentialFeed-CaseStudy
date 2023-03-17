//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 16/03/23.
//

import EssentialFeed

func anyNSError() -> NSError{ NSError(domain: "any error", code: 1) }

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}
