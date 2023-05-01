//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 02/03/23.
//

import Foundation

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public final class FeedPresenter {
    private let loadingView: ResourceLoadingView
    private let feedView: FeedView
    private let errorView: FeedErrorView

    public init(feedView: FeedView, loadingView: ResourceLoadingView, errorView: FeedErrorView) {
        self.feedView = feedView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    public static var title: String {
        Localized.Feed.title
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: Localized.Shared.loadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}

