//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 06/03/23.
//

import XCTest
import EssentialFeed

class FeedImageDataMapperTests: XCTestCase {
    
    
    func test_map_throwsInvalidDataErrorOnNon200HTTPResponse() throws {
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedImageDataMapper.map(anyData(), from: HTTPResponse(forCode: code))
            )
        }
    }
    
    func test_map_throwsInvalidDataErrorOn200HTTPResponseWithEmptyData() throws {
        let emptyData = Data()
        
        XCTAssertThrowsError(
            try FeedImageDataMapper.map(emptyData, from: HTTPResponse(forCode: 200))
        )
        
    }
    
    func test_map_deliversNonEmptyDataOn200HTTPResponse() throws {
        let nonEmptyData = Data("non-empty-data".utf8)

        let result = try FeedImageDataMapper.map(nonEmptyData, from: HTTPResponse(forCode: 200))
        
        XCTAssertEqual(result, nonEmptyData)
    }    
}
