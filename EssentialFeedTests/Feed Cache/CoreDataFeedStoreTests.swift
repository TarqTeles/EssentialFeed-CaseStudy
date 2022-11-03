//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 03/11/22.
//

import XCTest
import EssentialFeed

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {

    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {

    }
    
    func test_insert_deliverNoErrorOnEmptyCache() {

    }
    
    func test_insert_deliverNoErrorOnNonEmptyCache() {

    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {

    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {

    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {

    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {

    }
    
    func test_delete_deliversNoErrorOnPreviouslyInsertedCacheDeletion() {

    }
    
    func test_storeSideEffects_runSerially() {

    }
        
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
        let sut = CoreDataFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }
}
