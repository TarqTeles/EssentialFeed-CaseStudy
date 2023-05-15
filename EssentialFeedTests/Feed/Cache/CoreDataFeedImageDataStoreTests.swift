//
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 09/03/23.
//

import XCTest
import EssentialFeed

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
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSUT()
        let storedData = anyData()
        let matchingURL = URL(string: "https://a-url.com")!
        
        insert(storedData, for: matchingURL, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedData), forURL: matchingURL)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)
        let url = URL(string: "https://a-url.com")!
        
        insert(firstStoredData, for: url, into: sut)
        insert(lastStoredData, for: url, into: sut)

        expect(sut, toCompleteRetrievalWith: found(lastStoredData), forURL: url)
    }
    
    func test_sideEffects_runSerially() {
        let sut = makeSUT()
        let url = anyURL()
        
        let exp1 = expectation(description: "Operation 1")
        sut.insert([localImage(for: url)], timestamp: Date(), completion: { _ in
            exp1.fulfill()
        })
        
        let exp2 = expectation(description: "Operation 2")
        sut.insert(anyData(), for: url, completion: { _ in exp2.fulfill()})
        
        let exp3 = expectation(description: "Operation 3")
        sut.insert(anyData(), for: url, completion: { _ in exp3.fulfill()})
        
        wait(for: [exp1, exp2, exp3], timeout: 5.0, enforceOrder: true)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataFeedStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func notFound() -> FeedImageDataStore.RetrievalResult {
        .success(.none)
    }

    private func found(_ data: Data) -> FeedImageDataStore.RetrievalResult {
        .success(data)
    }

    private func localImage(for url: URL) -> LocalFeedImage {
        return LocalFeedImage(id: UUID(), description: "any description", location: "any location", url: url)
    }
    
    private func expect(_ sut: CoreDataFeedStore, toCompleteRetrievalWith expectedResult: FeedImageDataStore.RetrievalResult, forURL url: URL, file: StaticString = #filePath, line: UInt = #line) {
        let receivedResult = Result { try sut.retrieve(dataForURL: url) }
        
        switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), received \(receivedResult) instead", file: file, line: line)
        }
    }
    
    private func insert(_ data: Data, for url: URL, into sut: CoreDataFeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Witing for store insertion")
        let image = localImage(for: url)
        
        sut.insert([image], timestamp: Date()) { result in
            if case let .failure(error) = result {
                XCTFail("Failed to save image \(image) with error \(error)", file:  file, line: line)
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
        
        do {
            try sut.insert(data, for: image.url)
        } catch {
            XCTFail("Failed to insert data \(data) with error \(error)", file: file, line: line)
        }
    }
}
