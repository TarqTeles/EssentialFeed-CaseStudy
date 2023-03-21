//
//  FeedLoaderPresenterAdapter.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 23/01/23.
//

import EssentialFeed
import EssentialFeediOS

final class FeedLoaderPresenterAdapter: FeedViewControllerDelegate {
    private let feedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        
        feedLoader.load { [weak presenter] result in
            switch result {
                case let .success(feed):
                    presenter?.didFinishLoadingFeed(with: feed)
                case let .failure(error):
                    presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
