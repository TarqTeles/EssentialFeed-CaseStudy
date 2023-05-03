//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 16/03/23.
//

@testable import EssentialFeed

func anyNSError() -> NSError{ NSError(domain: "any error", code: 1) }

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func uniqueFeed() -> [FeedImage] {
    return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}

var loadError: String {
    Localized.Shared.loadError
}

var feedTitle: String {
    Localized.Feed.title
}

var commentsTitle: String {
    Localized.ImageComments.title
}
