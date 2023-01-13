//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 10/01/23.
//

import EssentialFeed




//final class FeedImageViewModel<Image> {
//    typealias Observer<T> = (T) -> Void
//
//    private var task: FeedImageDataLoaderTask?
//    private let model: FeedImage
//    private let imageLoader: FeedImageDataLoader
//    private let imageTransformer: (Data) -> Image?
//
//    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
//        self.model = model
//        self.imageLoader = imageLoader
//        self.imageTransformer = imageTransformer
//    }
//
//    var description: String? { model.description }
//
//    var location: String? { model.location }
//
//    var hasLocation: Bool { model.location != nil }
//
//    var onImageLoad: Observer<Image>?
//    var onImageLoadingStateChange: Observer<Bool>?
//    var onShouldRetryImageLoadingChangeState: Observer<Bool>?
//
//    func loadImageData() {
//        onImageLoadingStateChange?(true)
//        onShouldRetryImageLoadingChangeState?(false)
//
//        task = self.imageLoader.loadImageData(from: self.model.url) { [weak self] result in
//            self?.handle(result)
//        }
//
//    }
//
//    func handle(_ result: FeedImageDataLoader.Result) {
//        if let image = (try? result.get()).flatMap(imageTransformer) {
//            onImageLoad?(image)
//        } else {
//            onShouldRetryImageLoadingChangeState?(true)
//        }
//        onImageLoadingStateChange?(false)
//    }
//
//    func cancelImageDataLoad() {
//        task?.cancel()
//        task = nil
//    }
//
//}
