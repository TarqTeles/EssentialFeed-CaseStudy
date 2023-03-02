//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 02/03/23.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}
class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToViews() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages on init")
    }
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
    
}
