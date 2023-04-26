//
//  LoadFeedFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 05/10/22.
//

import XCTest
import EssentialFeed

final class FeedItemsMapperTests: XCTestCase {

    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199,201,404,500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPResponse(forCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPResponse(forCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        let mappedResult = try FeedItemsMapper.map(emptyListJSON, from: HTTPResponse(forCode: 200))
        
        XCTAssertEqual(mappedResult, [])
    }
    
    func test_map_deliverItemsOn200HTTPResponseWithJSONItems() throws {
        let item1 = makeItem(id: UUID(), imageURL: URL(string: "https://a-url.com")!)
        let item2 = makeItem(id: UUID(), description: "a description", location: "a location", imageURL: URL(string: "https://another-url.com")!)
        let items = [item1.model, item2.model]
        
        let json = makeItemsJSON([item1.json, item2.json])
        let mappedResult = try FeedItemsMapper.map(json, from: HTTPResponse(forCode: 200))
        
        XCTAssertEqual(mappedResult, items)
    }
    
    //MARK: -> Helpers

    private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
        return .failure(error)
    }
    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String:Any]) {
        let item = FeedImage(
            id: id,
            description: description,
            location: location,
            url: imageURL
        )
        
        let itemJSON: [String:Any] = [
            "id" : item.id.uuidString,
            "description" : item.description,
            "location" : item.location,
            "image" : item.url.absoluteString
        ].compactMapValues({$0})

        return (item, itemJSON)
    }
    
    private func HTTPResponse(forCode statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
    private func makeItemsJSON(_ items: [[String:Any]]) -> Data {
        let json = [ "items" : items ]
        return try! JSONSerialization.data(withJSONObject: json)
    }    
}
