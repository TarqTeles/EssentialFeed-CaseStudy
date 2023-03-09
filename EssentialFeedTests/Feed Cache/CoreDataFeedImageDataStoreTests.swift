//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 09/03/23.
//

import XCTest
import EssentialFeed
import Foundation

extension CoreDataFeedStore: FeedImageDataStore {
    public func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
        completion(.success(.none))
    }
}

class CoreDataFeedImageDataStoreTests: XCTestCase {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: notFound(), forURL: anyURL())
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataFeedStore {
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func notFound() -> FeedImageDataStore.RetrievalResult {
        .success(.none)
    }
    
    private func expect(_ sut: CoreDataFeedStore, toCompleteWith expectedResult: FeedImageDataStore.RetrievalResult, forURL url: URL, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wainting for store retieval")
        
        sut.retrieve(dataForURL: url) { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedData), .success(expectedData)):
                    XCTAssertEqual(receivedData, expectedData)
                    
                default:
                    XCTFail("Expected \(expectedResult), received \(receivedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
