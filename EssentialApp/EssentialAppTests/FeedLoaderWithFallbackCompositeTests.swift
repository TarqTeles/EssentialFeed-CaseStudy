//
//  FeedLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 15/03/23.
//

import XCTest
import EssentialFeed

final class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primaryLoader: FeedLoader
    private let fallbackLoader: FeedLoader
    
    init(primary: FeedLoader, fallback: FeedLoader) {
        self.primaryLoader = primary
        self.fallbackLoader = fallback
    }
    
    func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) {
        primaryLoader.load { [weak self] result in
            switch result {
                case .success:
                    completion(result)
                    
                case .failure:
                    self?.fallbackLoader.load(completion: completion)
            }
        }
    }
}


class FeedLoaderWithFallbackCompositeTests: XCTestCase {
    
    func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
        let primaryFeed = uniqueFeed()
        let fallbackFeed = uniqueFeed()
        let primaryLoader = LoaderStub(received: .success(primaryFeed))
        let fallbackLoader = LoaderStub(received: .success(fallbackFeed))
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
                case let .success(receivedFeed):
                    XCTAssertEqual(receivedFeed, primaryFeed)
                    
                case let .failure(error):
                    XCTFail("Expected success, got failure with \(error) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    func test_load_deliversFallbackFeedOnPrimaryLoaderFailure() {
        let fallbackFeed = uniqueFeed()
        let primaryLoader = LoaderStub(received: .failure(anyNSError()))
        let fallbackLoader = LoaderStub(received: .success(fallbackFeed))
        let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
        
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
                case let .success(receivedFeed):
                    XCTAssertEqual(receivedFeed, fallbackFeed)
                    
                case let .failure(error):
                    XCTFail("Expected success, got failure with \(error) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers
    
    private class LoaderStub: FeedLoader {
        let result: FeedLoader.Result
        
        init(received: FeedLoader.Result) {
            self.result = received
        }
        
        func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) {
            completion(result)
        }
    }
    
    private func uniqueFeed() -> [FeedImage] {
        return [FeedImage(id: UUID(), description: "any", location: "any", url: URL(string: "https://a-url.com")!)]
    }

    private func anyNSError() -> NSError{ NSError(domain: "any error", code: 1) }
}
