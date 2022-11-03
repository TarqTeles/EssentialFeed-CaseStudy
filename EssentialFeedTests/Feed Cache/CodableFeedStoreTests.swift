//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 31/10/22.
//

import XCTest
import EssentialFeed

class CodableFeedStoreTests: XCTestCase, FailableStoreSpecs {

    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }

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

        assertThatRetrieveDeliversEmptyOnEmptyCache(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(sut)
    }
    
    func test_retrieve_deliversFailureOnRetrievalError() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        assertThatRetrieveDeliversFailureOnRetrievalError(sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        let storeURL = testSpecificStoreURL()
        let sut = makeSUT(storeURL: storeURL)

        try! "invalid data".write(to: storeURL, atomically: false, encoding: .utf8)
        
        assertThatRetrieveHasNoSideEffectsOnFailure(sut)
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
        let sut = makeSUT()

        assertThatInsertOverridesPreviouslyInsertedCacheValues(sut)
    }
    
    func test_insert_deliversErrorOnInsertionError() {
        let invalidStore = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStore)
        
        assertThatInsertDeliversErrorOnInsertionError(sut)
    }
    
    func test_insert_hasNoSideEffectsOnInsertionError() {
        let invalidStore = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStore)
        
        assertThatInsertHasNoSideEffectsOnInsertionError(sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()

        assertThatDeleteHasNoSideEffectsOnEmptyCache(sut)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()

        assertThatDeleteDeliversNoErrorOnEmptyCache(sut)
    }
    
    func test_delete_deliversNoErrorOnPreviouslyInsertedCacheDeletion() {
        let sut = makeSUT()
        
        assertThatDeleteDeliversNoErrorOnPreviouslyInsertedCacheDeletion(sut    )
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        
        assertThatDeleteEmptiesPreviouslyInsertedCache(sut)
    }
    
    func test_delete_deliversErrorOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)

        assertThatDeleteDeliversErrorOnDeletionError(sut)
    }
    
    func test_delete_hasNoSideEffectsOnDeletionError() {
        let noDeletePermissionURL = cachesDirectory()
        let sut = makeSUT(storeURL: noDeletePermissionURL)

        assertThatDeleteHasNoSideEffectsOnDeletionError(sut)
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        
        assertThatStoreSideEffectsRunSerially(sut)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(storeURL: URL? = nil, file: StaticString = #filePath, line: UInt = #line) -> FeedStore {
        let storeURL = storeURL ?? testSpecificStoreURL()
        let sut = CodableFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }
    
    private func setupEmptyStoreState() {
        deleteTestStoreArtifacts()
    }

    private func undoStoreSideEffects() {
        deleteTestStoreArtifacts()
    }

    private func deleteTestStoreArtifacts() {
        try? FileManager.default.removeItem(at: testSpecificStoreURL())
    }
    
    private func testSpecificStoreURL() -> URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent("\(type(of: self)).store")
    }

    private func cachesDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .systemDomainMask).first!
    }
}
