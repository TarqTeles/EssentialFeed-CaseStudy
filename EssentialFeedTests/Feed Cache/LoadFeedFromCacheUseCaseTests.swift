//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 24/10/22.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMesssageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load {_ in }

        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        let exp = expectation(description: "Wait for load completion")
        
        var receivedError: Error?
        sut.load { result in
            switch result {
                case let .failure(error):
                    receivedError = error

                default:
                    XCTFail("Expected failure, got \(result) instead")
            }
            exp.fulfill()
        }

        store.completeRetrieval(with: retrievalError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, retrievalError)
    }
    
//    func test_load_deliverNoImagesOnEmptyCache() {
//        let (sut, store) = makeSUT()
//        let exp = expectation(description: "Wait for load completion")
//
//        var receivedImages: [FeedImage]?
//        sut.load { result in
//            receivedImages =
//            exp.fulfill()
//        }
//
//        store.completeRetrieval(with: retrievalError)
//        wait(for: [exp], timeout: 1.0)
//
//        XCTAssertEqual(receivedImages, [])
//    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)

        return (sut, store)
    }

    private func anyNSError() -> NSError{ NSError(domain: "any error", code: 1) }

}
