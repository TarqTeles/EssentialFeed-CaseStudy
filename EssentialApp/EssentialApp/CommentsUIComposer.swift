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
    
    public static func commentsComposedWith(commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>(loader: commentsLoader)
        
        let commentsController = makeCommentsViewController(title: ImageCommentsPresenter.title)
        commentsController.onRefresh = presentationAdapter.loadResource
        
        let presenter = LoadResourcePresenter(resourceView: CommentsViewAdapter(controller: commentsController),
                                              loadingView: WeakRefVirtualProxy(commentsController),
                                              errorView: WeakRefVirtualProxy(commentsController),
                                              mapper: { ImageCommentsPresenter.map($0) })
        
        presentationAdapter.presenter = presenter
        return commentsController
    }
    
    private static func makeCommentsViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let commentsController = storyboard.instantiateInitialViewController() as! ListViewController
        commentsController.title = title
        return commentsController
    }
}

final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?
    
    init(controller: ListViewController) {
        self.controller = controller
    }
    
    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { vm in
            CellController(id: vm, ImageCommentCellController(viewModel: vm))
        })
    }
}

