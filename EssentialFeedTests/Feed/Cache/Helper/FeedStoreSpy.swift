//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 24/10/22.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
    enum ReceivedMessage: Equatable {
        case deleteCachedFeed
        case insert([LocalFeedImage], Date)
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var retrievalResult: Result<CachedFeed?, Error>?
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    
    func deleteCachedFeed() throws {
        receivedMessages.append(.deleteCachedFeed)
        if case let .failure(error) = deletionResult {
            throw error
        }
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionResult = .failure(error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionResult = .success(())
    }
    
    func completeInsertion(with error: NSError, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func insert(_ feed: [LocalFeedImage], timestamp: Date) throws {
        receivedMessages.append(.insert(feed, timestamp))
        if case let .failure(error) = insertionResult {
            throw error
        }
    }
    
    func retrieve() throws -> CachedFeed? {
        receivedMessages.append(.retrieve)
        guard let retrievalResult = self.retrievalResult else { return nil }

        switch retrievalResult {
            case let .success(cache):
                return cache
            case let .failure(error):
                throw error
        }
    }
    
    func completeRetrieval(with error: NSError, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalResult = .success(.none)
    }
    
    func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
        retrievalResult = .success(CachedFeed(feed, timestamp))
    }
}
