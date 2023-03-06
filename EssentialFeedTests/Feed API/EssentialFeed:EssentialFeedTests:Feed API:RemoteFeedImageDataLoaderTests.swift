//
//  EssentialFeed:EssentialFeedTests:Feed API:RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 06/03/23.
//

import XCTest

final class RemoteFeedImageDataLoader {
    
    init(client: Any) {
        
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private final class HTTPClientSpy {
        let requestedURLs = [URL]()
        
    }
}
