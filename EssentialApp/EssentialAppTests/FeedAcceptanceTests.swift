//
//  FeedAcceptanceTests.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 21/03/23.
//

import XCTest
import EssentialFeed
import EssentialFeediOS
@testable import EssentialApp

final class FeedAcceptanceTests: XCTestCase {

    func test_onLaunch_displayRemoteFeedWhenCustomerHAsConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData())
    }
    
    func test_onLaunch_displaysEmptyFeedWhenCustomerHasNoConnectivityAndNoCache() {
        let feed = launch(httpClient: .offline, store: .empty)
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 0)
    }
    
    func test_onEnteringBackgroud_deleteExpiredCache() {
        let store = InMemoryFeedStore.withExpiredFeedCache

         enterBackground(with: store)

         XCTAssertNil(store.feedCache, "Expected to delete expired cache")
    }

    func test_onEnteringBackgroud_doesNotDeleteNonExpiredCache() {
        let store = InMemoryFeedStore.withNonExpiredFeedCache

         enterBackground(with: store)

         XCTAssertNotNil(store.feedCache, "Expected non-expired cache to be kept")
    }
    
    func test_onFeedImageSelection_displaysComments() {
        let comments = showCommentsForFirstImage()
        
        XCTAssertEqual(comments.numberOfRenderedComments(), 1)
        XCTAssertEqual(comments.commentMessage(at: 0), aCommentMessage)
    }

    // MARK: - Helpers
    
    private func launch(
        httpClient: HTTPClientStub = .offline,
        store: InMemoryFeedStore = .empty
    ) -> ListViewController {
        let sut = SceneDelegate(httpClient: httpClient, store: store)
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func enterBackground(with store: InMemoryFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline, store: store)
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
    
    private func showCommentsForFirstImage() -> ListViewController {
        let feed = launch(httpClient: .online(response), store: .empty)

        feed.simulateTapOnFeedImage(at: 0)
        ListViewController.executeRunLoopToCleanUpReferences()
        
        let nav = feed.navigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.absoluteString {
            case "http://image-1.com", "http://image-2.com":
                return makeImageData()
                
            case "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed":
                return makeFeedData()
                
            case "https://ile-api.essentialdeveloper.com/essential-feed/v1/image/9ED8D126-337E-43F4-A217-79D898CFE380/comments":
                return makeCommentData()

            default:
                XCTFail("unrecognized url")
                return Data("invalid utl".utf8)
        }
    }
    
    private func makeImageData() -> Data {
        UIImage.make(withColor: .red).pngData()!
    }
    
    private func makeFeedData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "9ED8D126-337E-43F4-A217-79D898CFE380", "image": "http://image-1.com"],
            ["id": "2490D6A1-BEB4-4E6C-8112-CC240930BC04", "image": "http://image-2.com"]
        ]])
    }
    
    private func makeCommentData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": UUID().uuidString,
             "message": aCommentMessage,
             "created_at": "2023-02-28T15:07:02+00:00",
             "author" : [
                 "username" : "a username"
                 ]
            ] as [String : Any]
        ]])
    }
    
    private var aCommentMessage: String { "a message" }
}
