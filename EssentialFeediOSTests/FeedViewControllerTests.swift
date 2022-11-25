//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Tarquinio Teles on 25/11/22.
//

import XCTest
import UIKit

class FeedViewController: UIViewController {
    private var loader: FeedViewControllerTests.LoaderSpy?
    
    convenience init(loader: FeedViewControllerTests.LoaderSpy) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load()
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)

    }
    
    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
        
        func load() {
            loadCallCount += 1
        }
    }
}
