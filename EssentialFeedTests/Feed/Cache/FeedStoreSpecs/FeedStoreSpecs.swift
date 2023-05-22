//
//  FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 02/11/22.
//

import Foundation

protocol FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache()
    
    func test_insert_deliverNoErrorOnEmptyCache()
    func test_insert_deliverNoErrorOnNonEmptyCache()
    func test_insert_overridesPreviouslyInsertedCacheValues()

    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_deliversNoErrorOnEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()
    func test_delete_deliversNoErrorOnPreviouslyInsertedCacheDeletion()
}

protocol FailableRetrieveFeedStoreSpecs: FeedStoreSpecs {
    func test_retrieve_deliversFailureOnRetrievalError()
    func test_retrieve_hasNoSideEffectsOnFailure()
}

protocol FailableInsertFeedStoreSpecs: FeedStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeleteFeedStoreSpecs: FeedStoreSpecs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailableStoreSpecs = FailableRetrieveFeedStoreSpecs & FailableInsertFeedStoreSpecs & FailableDeleteFeedStoreSpecs
