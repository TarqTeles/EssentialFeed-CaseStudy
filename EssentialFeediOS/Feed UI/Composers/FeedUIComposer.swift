//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 05/01/23.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresenterAdapter(feedLoader: MainThreadDispatchDecorator(decoratee: feedLoader))

        let feedController = FeedViewController.makeWith(delegate: presentationAdapter,
                                                         title: FeedPresenter.title)
        
        let presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedController,
                                                                loader: MainThreadDispatchDecorator(decoratee: imageLoader)),
                                      loadingView: WeakRefVirtualProxy(feedController))
        presentationAdapter.presenter = presenter
        return feedController
    }
}

private extension FeedViewController {
    static func makeWith(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
