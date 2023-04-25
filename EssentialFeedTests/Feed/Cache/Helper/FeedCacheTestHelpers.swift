//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 27/10/22.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let feed = [uniqueImage(), uniqueImage()]
    let localFeed = feed.map({ LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) })
    
    return (feed, localFeed)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        return self.adding(days: -feedCacheMaxAgeInDays())
    }
    
    private func feedCacheMaxAgeInDays() -> Int {
        return 7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
