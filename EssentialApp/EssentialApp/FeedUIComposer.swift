//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 05/01/23.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresenterAdapter(feedLoader: feedLoader)
        
        let feedController = makeFeedViewController(delegate: presentationAdapter,
                                                    title: FeedPresenter.title)
        
        let presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: feedController,
                                                                            loader: imageLoader),
                                              loadingView: WeakRefVirtualProxy(feedController),
                                              errorView: WeakRefVirtualProxy(feedController),
                                              mapper: FeedPresenter.map)
        presentationAdapter.presenter = presenter
        return feedController
    }
    
    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
