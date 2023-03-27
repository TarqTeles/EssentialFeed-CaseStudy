//
//  FeedLoaderPresenterAdapter.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 23/01/23.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class FeedLoaderPresenterAdapter: FeedViewControllerDelegate {
    private let feedLoader: () -> FeedLoader.Publisher
    private var cancellable: Cancellable?
    var presenter: FeedPresenter?

    init(feedLoader: @escaping () -> FeedLoader.Publisher) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        
        cancellable = feedLoader()
            .dispatchingOnMainQueue()
            .sink(
                receiveCompletion: { [weak presenter] completion in
                    switch completion {
                        case .finished: break
                        case let .failure(error):
                            presenter?.didFinishLoadingFeed(with: error)
                    }
                },
                receiveValue: { [weak presenter] feed in
                    presenter?.didFinishLoadingFeed(with: feed)
                })
    }
}
