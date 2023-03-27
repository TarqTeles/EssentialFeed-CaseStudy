//
//  FeedImageLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 23/01/23.
//

import Foundation
import Combine
import EssentialFeed
import EssentialFeediOS

final class FeedImageLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    private var cancellable: Cancellable?
    
    var presenter: FeedImagePresenter<View, Image>?
    
    init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        let model = self.model
        
        self.cancellable = imageLoader(model.url)
            .dispatchingOnMainQueue()
            .sink(
                receiveCompletion: { [weak presenter] completion in
                    switch completion {
                        case .finished: break
                        case let .failure(error):
                            presenter?.didFinishLoadingImageData(with: error, for: model)
                    }
                },
                receiveValue: { [weak presenter] data in
                    presenter?.didFinishLoadingImageData(with: data, for: model)
                })
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
