//
//  XCTestCase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 02/11/22.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversEmptyOnEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .success(.none), file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedFeed(feed: feed, timestamp: timestamp)))
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {

        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .success(CachedFeed(feed: feed, timestamp: timestamp)))
    }
    
    func assertThatInsertDeliverNoErrorOnEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func assertThatInsertDeliverNoErrorOnNonEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)

        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        let latestInsertionError = insert((latestFeed, latestTimestamp), to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
    }
    
    func assertThatInsertOverridesPreviouslyInsertedCacheValues(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)

        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .success(CachedFeed(feed: latestFeed, timestamp: latestTimestamp)))
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func assertThatDeleteDeliversNoErrorOnEmptyCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
    }
    
    func assertThatDeleteDeliversNoErrorOnPreviouslyInsertedCacheDeletion(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)

        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        insert((uniqueImageFeed().local, Date()), to: sut)

        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none))
    }
        
    func assertThatRetrieveDeliversFailureOnRetrievalError(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: .failure(anyNSError()))
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieveTwice: .failure(anyNSError()))
    }
    
    func assertThatInsertDeliversErrorOnInsertionError(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        let insertionError = insert((feed, timestamp), to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        
        insert((feed, timestamp), to: sut)

        expect(sut, toRetrieve: .success(.none))
    }
    
    func assertThatDeleteDeliversErrorOnDeletionError(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(_ sut: FeedStore, file: StaticString = #filePath, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func expect(_ sut: FeedStore, toRetrieveTwice expectedResult: Result<CachedFeed?,Error>, file: StaticString = #filePath, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    func expect(_ sut: FeedStore, toRetrieve expectedResult: Result<CachedFeed?,Error>, file: StaticString = #filePath, line: UInt = #line) {
        
        let retrieveResult = Result<CachedFeed?,Error> { try sut.retrieve() }

        switch (retrieveResult, expectedResult) {
            case let (.success(.some(receivedCache)), .success(.some(expectedCache))):
                XCTAssertEqual(receivedCache.feed, expectedCache.feed, file: file, line: line)
                XCTAssertEqual(receivedCache.timestamp, expectedCache.timestamp, file: file, line: line)
                
            case (.success(.none), .success(.none)),
                (.failure, .failure):
                break
                
            default:
                XCTFail("Expected result \(expectedResult), got \(retrieveResult) instead")
        }
    }
    
    @discardableResult
    func insert(_ cache: (feed: [LocalFeedImage], timestamp: Date), to sut: FeedStore) -> Error? {
        do {
            try sut.insert(cache.feed, timestamp: cache.timestamp)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func deleteCache(from sut: FeedStore) -> Error? {
        do {
            try sut.deleteCachedFeed()
            return nil
        } catch {
            return error
        }
    }
    

}
