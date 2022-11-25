//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Tarquinio Teles on 25/11/22.
//

import XCTest

class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {
        
    }
    
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
