//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 02/03/23.
//

import Foundation

public final class FeedPresenter {
    public static var title: String {
        Localized.Feed.title
    }
    
    public static func map(_ feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}

