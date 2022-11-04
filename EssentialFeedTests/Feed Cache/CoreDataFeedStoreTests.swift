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
        let sut = makeSUT()
        
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(sut)
    }
    
    func test_insert_deliverNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliverNoErrorOnEmptyCache(sut)
    }
    
    func test_insert_deliverNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatInsertDeliverNoErrorOnNonEmptyCache(sut)

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
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }
}
