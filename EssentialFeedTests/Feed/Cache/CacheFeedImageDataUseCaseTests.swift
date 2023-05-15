//
//  CacheFeedImageDataUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 08/03/23.
//

import XCTest
import EssentialFeed

class CacheFeedImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestsImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        try? sut.save(data, for: url)
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataForURL_failsOnStoreInsertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failed(), when: {
            store.completeInsertion(with: anyNSError())
        })
    }
    
    func test_saveImageDataForURL_succeedsOnSuccessfulDataInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: success(), when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init,
                         file: StaticString = #filePath,
                         line: UInt = #line
    ) -> (sut: LocalFeedImageDataLoader, store: FeedImageDataStoreSpy) {
        
        let store = FeedImageDataStoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader,
                        toCompleteWith expectedResult: Result<Void, Error>,
                        when action: () -> Void,
                        file: StaticString = #filePath,
                        line: UInt = #line) {
        
        action()
        
        let receivedResult = Result { try sut.save( anyData(), for: anyURL()) }
        
        switch (receivedResult, expectedResult) {
            case let (.failure(receivedError as LocalFeedImageDataLoader.SaveError),
                      .failure(expectedError as LocalFeedImageDataLoader.SaveError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            case (.success(), .success()):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead",
                        file: file,
                        line: line)
        }
    }

    private func success() -> Result<Void, Error> {
        return .success(())
    }

    private func failed() -> Result<Void, Error> {
        return failure(.failed)
    }
        
    private func failure(_ error: LocalFeedImageDataLoader.SaveError) -> Result<Void, Error> {
        return .failure(error)
    }

}
