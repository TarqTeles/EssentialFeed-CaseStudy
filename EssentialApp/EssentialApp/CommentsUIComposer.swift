//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 03/05/23.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class CommentsUIComposer {
    private init() {}
    
    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(loader: commentsLoader)
        
        let commentsController = makeCommentsViewController(title: ImageCommentsPresenter.title)
        commentsController.onRefresh = presentationAdapter.loadResource
        
        let presenter = LoadResourcePresenter(resourceView: FeedViewAdapter(controller: commentsController,
                                                                            loader: { _ in Empty<Data, Error>().eraseToAnyPublisher() }),
                                              loadingView: WeakRefVirtualProxy(commentsController),
                                              errorView: WeakRefVirtualProxy(commentsController),
                                              mapper: FeedPresenter.map)
        presentationAdapter.presenter = presenter
        return commentsController
    }
    
    private static func makeCommentsViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let commentsController = storyboard.instantiateInitialViewController() as! ListViewController
        commentsController.title = title
        return commentsController
    }
}
