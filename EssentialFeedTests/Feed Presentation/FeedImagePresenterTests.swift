//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 02/03/23.
//

import XCTest

final class FeedImagePresenter {
    init(view: Any) {
        
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToViews() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no messages sent to view on FeedImagePresenter init")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(view, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
