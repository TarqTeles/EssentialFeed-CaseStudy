//
//  FeedCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 20/10/22.
//

import XCTest

class LocalFeedLoader {
    let store: FeedStore
    
    init(store: FeedStore) {
        self.store = store
    }
}


class FeedStore {
    let deleteCacheFeedCallCount = 0
}

final class FeedCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteStoreUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCacheFeedCallCount, 0)
    }
}
