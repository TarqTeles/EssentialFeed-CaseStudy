//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 14/03/23.
//

import os
import UIKit
import CoreData
import Combine
import EssentialFeed
import EssentialFeediOS



class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    lazy var httpClient: HTTPClient = {
        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.essentialdeveloper.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent)
        .eraseToAnyScheduler()
    
    private lazy var logger = Logger(subsystem: "com.essentialdeveloper.EssentialAppCaseStudy",
                                     category: "main")
    
    lazy var store: FeedStore & FeedImageDataStore = {
        do {
            return try CoreDataFeedStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("feed-store.sqlite")
            )
        } catch {
            assertionFailure("Failed to instantiate CoreData FeedStore with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate CoreData FeedStore with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private lazy var navigationController = UINavigationController(
        rootViewController: FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: showComments)
    )
    
    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!

    private lazy var localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
    
    private lazy var localImageLoader = LocalFeedImageDataLoader(store: store)

    convenience init(httpClient: HTTPClient,
                     store: FeedStore & FeedImageDataStore,
                     baseURL: URL? = nil,
                     scheduler: AnyDispatchQueueScheduler? = nil
    ) {
        self.init()
        self.httpClient = httpClient
        self.store = store
        self.baseURL = baseURL ?? self.baseURL
        self.scheduler = scheduler ?? self.scheduler
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
     
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        do {
            try localFeedLoader.validateCache()
        } catch {
            logger.error("Received \(error.localizedDescription) when validating cache")
        }
    }
    
    private func showComments(_ image: FeedImage) {
        let url = ImageCommentEndpoint.get(image.id).url(baseURL: baseURL)
        let view = CommentsUIComposer
            .commentsComposedWith(commentsLoader: makeCommentsLoader(url: url))
        
        navigationController.pushViewController(view, animated: true)
    }
    
    private func makeCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        { [httpClient] in
            httpClient
                .getPublisher(url: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        makeRemoteFeedLoader()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map(makeFirstPage)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteLoadMoreLoader(last: FeedImage?) -> AnyPublisher<Paginated<FeedImage>, Error> {
        localFeedLoader.loadPublisher()
            .zip(makeRemoteFeedLoader(after: last))
            .map { (cachedItems, newItems) in
                (cachedItems + newItems, newItems.last)
            }.map(makePage)
            .caching(to: localFeedLoader)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader(after last: FeedImage? = nil) -> AnyPublisher<[FeedImage], Error> {
        let url = FeedEndpoint.get(after: last).url(baseURL: baseURL)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(items: [FeedImage]) -> Paginated<FeedImage> {
        makePage(items: items, last: items.last)
    }
    
    private func makePage(items: [FeedImage], last: FeedImage?) -> Paginated<FeedImage> {
        return Paginated(items: items,
                         loadMorePublisher: last.map { last in
            { self.makeRemoteLoadMoreLoader(last: last) }
        })
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> LocalFeedImageDataLoader.Publisher {
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: { [httpClient, scheduler] in
                httpClient
                    .getPublisher(url: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: self.localImageLoader, using: url)
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
