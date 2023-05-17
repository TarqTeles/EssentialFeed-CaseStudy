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
    
    func test_onLaunch_displayRemoteFeedWhenCustomerHasConnectivity() {
        let feed = launch(httpClient: .online(response), store: .empty)
        feed.loadViewIfNeeded()
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 2)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertTrue(feed.canLoadMoreFeed)
        
        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertTrue(feed.canLoadMoreFeed)
        
        feed.simulateLoadMoreFeedAction()
        
        XCTAssertEqual(feed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(feed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(feed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(feed.renderedFeedImageData(at: 2), makeImageData2())
        XCTAssertFalse(feed.canLoadMoreFeed)
    }
    
    func test_onLaunch_displaysCachedRemoteFeedWhenCustomerHasNoConnectivity() {
        let sharedStore = InMemoryFeedStore.empty
        let onlineFeed = launch(httpClient: .online(response), store: sharedStore)
        onlineFeed.simulateFeedImageViewVisible(at: 0)
        onlineFeed.simulateFeedImageViewVisible(at: 1)
        onlineFeed.simulateLoadMoreFeedAction()
        onlineFeed.simulateFeedImageViewVisible(at: 2)
        
        let offlineFeed = launch(httpClient: .offline, store: sharedStore)
        XCTAssertEqual(offlineFeed.numberOfRenderedFeedImageViews(), 3)
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 0), makeImageData0())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 1), makeImageData1())
        XCTAssertEqual(offlineFeed.renderedFeedImageData(at: 2), makeImageData2())
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
        let sut = SceneDelegate(httpClient: httpClient,
                                store: store,
                                baseURL: fakeBaseURL,
                                scheduler: .immediateOnMainQueue
        )
        sut.window = UIWindow()
        sut.configureWindow()
        
        let nav = sut.window?.rootViewController as? UINavigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func enterBackground(with store: InMemoryFeedStore) {
        let sut = SceneDelegate(httpClient: HTTPClientStub.offline,
                                store: store,
                                baseURL: fakeBaseURL,
                                scheduler: .immediateOnMainQueue
        )
        sut.sceneWillResignActive(UIApplication.shared.connectedScenes.first!)
    }
    
    private let fakeBaseURL = URL(string: "http://some-url.com/essential-feed/")!
    
    private func showCommentsForFirstImage() -> ListViewController {
        let feed = launch(httpClient: .online(response), store: .empty)
        
        feed.simulateTapOnFeedImage(at: 0)
        ListViewController.executeRunLoopToCleanUpReferences()
        
        let nav = feed.navigationController
        return nav?.topViewController as! ListViewController
    }
    
    private func response(for url: URL) -> (Data, HTTPURLResponse) {
        let response = HTTPURLResponse(url: url,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil
        )!
        return (makeData(for: url), response)
    }
    
    private func makeData(for url: URL) -> Data {
        switch url.path {
            case "/image-0": return makeImageData0()
            case "/image-1": return makeImageData1()
            case "/image-2": return makeImageData2()
                
            case "/essential-feed/v1/feed" where url.query?.contains("after_id") == false:
                return makeFirstFeedPageData()
                
            case "/essential-feed/v1/feed" where
                url.query?.contains("after_id=2490D6A1-BEB4-4E6C-8112-CC240930BC04") == true:
                return makeSecondFeedPageData()
                
            case "/essential-feed/v1/feed" where
                url.query?.contains("after_id=166FCDD7-C9F4-420A-B2D6-CE2EAFA3D82F") == true:
                return makeLastEmptyFeedPageData()
                
            case "/essential-feed/v1/image/9ED8D126-337E-43F4-A217-79D898CFE380/comments":
                return makeCommentData()
                
            default:
                XCTFail("unrecognized url \(url)")
                return Data("invalid utl".utf8)
        }
    }
    
    private func makeImageData0() -> Data { UIImage.make(withColor: .red).pngData()! }
    private func makeImageData1() -> Data { UIImage.make(withColor: .green).pngData()! }
    private func makeImageData2() -> Data { UIImage.make(withColor: .blue).pngData()! }
    
    private func makeFirstFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "9ED8D126-337E-43F4-A217-79D898CFE380", "image": "http://some-url.com/image-0"],
            ["id": "2490D6A1-BEB4-4E6C-8112-CC240930BC04", "image": "http://some-url.com/image-1"]
        ]])
    }
    
    private func makeSecondFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [
            ["id": "166FCDD7-C9F4-420A-B2D6-CE2EAFA3D82F", "image": "http://feed.com/image-2"],
        ]])
    }
    
    private func makeLastEmptyFeedPageData() -> Data {
        return try! JSONSerialization.data(withJSONObject: ["items": [Any]()])
    }
    
    private var aCommentMessage: String { "a message" }
    
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

}
