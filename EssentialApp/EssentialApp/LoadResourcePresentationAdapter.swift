//
//  FeedLoaderPresenterAdapter.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 23/01/23.
//

import Combine
import EssentialFeed
import EssentialFeediOS

final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
    private let loader: () -> AnyPublisher<Resource, Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<Resource, View>?

    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func loadResource() {
        presenter?.didStartLoading()
        
        cancellable = loader()
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

extension LoadResourcePresentationAdapter: FeedViewControllerDelegate {
    func didRequestFeedRefresh() {
        self.loadResource()
    }
}
