//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 14/03/23.
//

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
    
    lazy var store: FeedStore & FeedImageDataStore = {
        try! CoreDataFeedStore(storeURL: NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        )
    }()
    
    private lazy var navigationController = UINavigationController(rootViewController: FeedUIComposer.feedComposedWith(
        feedLoader: makeRemoteFeedLoaderWithLocalFallback,
        imageLoader: makeLocalImageLoaderWithRemoteFallback,
        selection: showComments))
    
    private let baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!

    private lazy var localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
    
    private lazy var localImageLoader = LocalFeedImageDataLoader(store: store)

    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
     
    func configureWindow() {
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
        
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        localFeedLoader.validateCache { _ in }
    }
    
    private func showComments(_ image: FeedImage) {
        let url = baseURL.appending(path: "v1/image/\(image.id.uuidString)/comments")
        let view = CommentsUIComposer.commentsComposedWith(commentsLoader: makeCommentsLoader(url: url))
        
        navigationController.pushViewController(view, animated: true)
    }
    
    private func makeCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        return {
            self.httpClient
                .getPublisher(url: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        return httpClient
            .getPublisher(url: FeedEndpoint.get.url(baseURL: baseURL))
            .tryMap(FeedItemsMapper.map)
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map { feed in
                Paginated(items: feed)
            }
            .eraseToAnyPublisher()
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> LocalFeedImageDataLoader.Publisher {
        return localImageLoader
            .loadImageDataPublisher(from: url)
            .fallback(to: {
                self.httpClient
                    .getPublisher(url: url)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: self.localImageLoader, using: url)
            })
    }
}
