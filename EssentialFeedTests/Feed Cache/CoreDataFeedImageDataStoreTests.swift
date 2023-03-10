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
        
        expect(sut, toCompleteRetrievalWith: notFound(), forURL: anyURL())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenSoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "https://a-given-url.com")!
        let nonMatchingURL = URL(string: "https://non-matching-url.com")!
        
        insert(anyData(), for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), forURL: nonMatchingURL)
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
    
    private func localImage(for url: URL) -> LocalFeedImage {
        return LocalFeedImage(id: UUID(), description: "any description", location: "any location", url: url)
    }
    
    private func expect(_ sut: CoreDataFeedStore, toCompleteRetrievalWith expectedResult: FeedImageDataStore.RetrievalResult, forURL url: URL, file: StaticString = #file, line: UInt = #line) {
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
    
    private func insert(_ data: Data, for url: URL, into sut: CoreDataFeedStore, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Witing for store insertion")
        let image = localImage(for: url)
        
        sut.insert([image], timestamp: Date()) { result in
            switch result {
                case let .failure(error):
                    XCTFail("Failed to save image \(image) with error \(error)", file:  file, line: line)
                    
                case .success:
                    sut.insert(data, for: image.url) { result in
                        if case let .failure(error) = result {
                            XCTFail("Failed to insert data \(data) with error \(error)", file: file, line: line)
                        }
                    }
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}
