//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 31/10/22.
//

import XCTest
import EssentialFeed


class CodableFeedStore {
    private struct Cache: Codable {
        let feed: [LocalFeedImage]
        let timestamp: Date
    }
    
    private let storeURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("feed-image.store")
    
    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }
        
        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        return completion(.found(feed: cache.feed, timestamp: cache.timestamp))
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(Cache(feed: feed, timestamp: timestamp))
        try! data.write(to: storeURL)
        completion(nil)
    }
}

class CodableFeedStoreTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        
        let storeURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("feed-image.store")
        try? FileManager.default.removeItem(at: storeURL)
    }

    override class func tearDown() {
        super.tearDown()
        
        let storeURL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("feed-image.store")
        try? FileManager.default.removeItem(at: storeURL)
    }
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { result in
            switch result {
                case .empty:
                    break

                default:
                    XCTFail("Expected retrieving from cache to deliver empty result, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableFeedStore()
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                    case (.empty, .empty):
                        break

                    default:
                        XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }

                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_retrieveAfterInsertingToEmptyCache_deliversInsertedValues() {
        let sut = CodableFeedStore()
        let feed = uniqueImageFeed().local
        let timestamp = Date()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.insert(feed, timestamp: timestamp)  { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            
            sut.retrieve { retrievalResult in
                switch retrievalResult {
                    case let .found(feed: receivedFeed, timestamp: receivedTimestamp):
                        XCTAssertEqual(feed, receivedFeed)
                        XCTAssertEqual(timestamp, receivedTimestamp)
                        
                    default:
                        XCTFail("Expected found result with feed \(feed) and timestamp,\(timestamp), got \(retrievalResult) instead")
                }
                
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
    
}
