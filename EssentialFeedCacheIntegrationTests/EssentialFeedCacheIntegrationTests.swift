//
//  EssentialFeedCacheIntegrationTests.swift
//  EssentialFeedCacheIntegrationTests
//
//  Created by Tarquinio Teles on 07/11/22.
//

import XCTest
import EssentialFeed

final class EssentialFeedCacheIntegrationTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        
        undoStoreSideEffects()
    }

    // MARK: - LocalFeedLoader Tests
    
    func test_loadFeed_deliversNoItemsOnEmptyCache() {
        let feedLoader = makeFeedLoader()
        
        expect(feedLoader, toLoad: [])
    }
    
    func test_loadFeed_deliversItemsSavedOnASeparateInstance() {
        let feedLoaderToPerformSave = makeFeedLoader()
        let feedLoaderToPerformLoad = makeFeedLoader()
        let feed = uniqueImageFeed().models
        
        save(feed, with: feedLoaderToPerformSave)
        
        expect(feedLoaderToPerformLoad, toLoad: feed)
    }

    func test_loadFeed_overridesItemsSavedOnASeparateInstance() {
        let feedLoaderToPerformFirstSave = makeFeedLoader()
        let feedLoaderToPerformLastSave = makeFeedLoader()
        let feedLoaderToPerformLoad = makeFeedLoader()
        let firstFeed = uniqueImageFeed().models
        let latestFeed = uniqueImageFeed().models

        save(firstFeed, with: feedLoaderToPerformFirstSave)
        save(latestFeed, with: feedLoaderToPerformLastSave)
        
        expect(feedLoaderToPerformLoad, toLoad: latestFeed)
    }

    func test_validateFeedCache_doesNotDeleteRecentlySavedFeed() {
        let feedLoaderToPerformSave = makeFeedLoader()
        let feedLoaderToPerformValidation = makeFeedLoader()
        let feed = uniqueImageFeed().models
        
        save(feed, with: feedLoaderToPerformSave)
        validateCache(with: feedLoaderToPerformValidation)
        
        expect(feedLoaderToPerformSave, toLoad: feed)
    }

    func test_validateFeedCache_deletesFeedSavedOnADistantPast() {
        let feedLoaderToPerformSave = makeFeedLoader(currenDate: .distantPast)
        let feedLoaderToPerformValidation = makeFeedLoader()
        let feed = uniqueImageFeed().models
        
        save(feed, with: feedLoaderToPerformSave)
        validateCache(with: feedLoaderToPerformValidation)
        
        expect(feedLoaderToPerformSave, toLoad: [])
    }

    // MARK: - LocalFeedImageDataLoader Tests

    func test_loadImageData_deliversSavedDataOnSeparateInstance() {
        let imageLoaderToPerformSave = makeImageLoader()
        let imageLoaderToPerformLoad = makeImageLoader()
        let feedLoader = makeFeedLoader()
        let image = uniqueImage()
        let dataToSave = anyData()
        
        save([image], with: feedLoader)
        save(dataToSave, with: imageLoaderToPerformSave, for: image.url)
        
        expect(imageLoaderToPerformLoad, toLoad: dataToSave, from: image.url)

    }
    
    func test_loadImageData_overridesSavedDataOnSeparateInstance() {
        let imageLoaderToPerformFirstSave = makeImageLoader()
        let imageLoaderToPerformLastSave = makeImageLoader()
        let imageLoaderToPerformLoad = makeImageLoader()
        let feedLoader = makeFeedLoader()
        let image = uniqueImage()
        let firstDataToSave = Data("first".utf8)
        let latestDataToSave = Data("last".utf8)

        save([image], with: feedLoader)
        save(firstDataToSave, with: imageLoaderToPerformFirstSave, for: image.url)
        save(latestDataToSave, with: imageLoaderToPerformLastSave, for: image.url)

        expect(imageLoaderToPerformLoad, toLoad: latestDataToSave, from: image.url)

    }
    
    // MARK: - Helpers
    
    private func makeFeedLoader(currenDate: Date = Date(), file: StaticString = #filePath, line: UInt = #line) -> LocalFeedLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedLoader(store: store, currentDate: { currenDate })
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makeImageLoader(file: StaticString = #filePath, line: UInt = #line) -> LocalFeedImageDataLoader {
        let storeURL = testSpecificStoreURL()
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let sut = LocalFeedImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func validateCache(with sut: LocalFeedLoader, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for validation completion")
        sut.validateCache() { result in
            if case let Result.failure(error) = result {
                    XCTFail("Expected to vlidate cache successfully, got \(error) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: LocalFeedLoader, toLoad expectedFeed: [FeedImage], file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        sut.load { result in
            switch result {
                case let .success(receivedFeed):
                    XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
                    
                case let .failure(error):
                    XCTFail("Expected successful load result, got \(error) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func save(_ feed: [FeedImage], with sut: LocalFeedLoader, file: StaticString = #filePath, line: UInt = #line) {
        let saveResult = LocalFeedLoader.SaveResult { try sut.save(feed: feed) }
        if case let Result.failure(error) = saveResult {
            XCTFail("Expected to save feed successfully, got \(error) instead", file: file, line: line)
        }
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toLoad expectedData: Data?, from url: URL, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let receivedData = try sut.loadImageData(from: url)
            XCTAssertEqual(receivedData, expectedData, file: file, line: line)
        } catch {
            XCTFail("Expected successful load result, got \(error) instead", file: file, line: line)
        }
    }
    
    private func save(_ data: Data, with sut: LocalFeedImageDataLoader, for url: URL, file: StaticString = #filePath, line: UInt = #line) {
        do {
            try sut.save(data, for: url)
        } catch {
            XCTFail("Expected to save feed successfully, got \(error) instead", file: file, line: line)
        }
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
        return cacheDirectory().appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cacheDirectory() -> URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }
}
