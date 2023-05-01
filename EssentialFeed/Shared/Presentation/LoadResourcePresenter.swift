//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 01/05/23.
//

import Foundation

public protocol ResourceView {
    func display(_ resourceViewModel: String)
}
public final class LoadResourcePresenter {
    public typealias Mapper = (String) -> String
    
    private let loadingView: FeedLoadingView
    private let resourceView: ResourceView
    private let errorView: FeedErrorView
    private let mapper: Mapper

    public init(resourceView: ResourceView, loadingView: FeedLoadingView, errorView: FeedErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        errorView.display(.error(message: Localized.Feed.loadError))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
