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
    private let feedLoader: () -> AnyPublisher<[FeedImage], Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<[FeedImage], FeedViewAdapter>?

    init(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) {
        self.feedLoader = feedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoading()
        
        cancellable = feedLoader()
            .dispatchingOnMainQueue()
            .sink(
                receiveCompletion: { [weak presenter] completion in
                    switch completion {
                        case .finished: break
                        case let .failure(error):
                            presenter?.didFinishLoading(with: error)
                    }
                },
                receiveValue: { [weak presenter] feed in
                    presenter?.didFinishLoading(with: feed)
                })
    }
}
