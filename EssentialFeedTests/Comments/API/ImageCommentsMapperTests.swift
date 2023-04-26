//
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 25/04/23.
//

import XCTest
import EssentialFeed

final class ImageCommentsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon2xxHTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199,300,350,404,500]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(json, from: HTTPResponse(forCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn2xxHTTPResponseWithInvalidJSON() throws {
        let invalidJSON = Data("invalid json".utf8)
        let samples = [200,201,250,299]

        try samples.forEach { code in
            XCTAssertThrowsError(
                try ImageCommentsMapper.map(invalidJSON, from: HTTPResponse(forCode: code))
            )
        }
    }
    
    func test_map_deliversNoItemsOn2xxHTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])
        let samples = [200,201,250,299]

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(emptyListJSON, from: HTTPResponse(forCode: code))
            XCTAssertEqual(result, [])
        }
    }
    
    func test_load_deliverItemsOn2xxHTTPResponseWithJSONItems() throws {
        let comment = aComment()
        let json = makeItemsJSON([comment.json])
        let samples = [200,201,250,299]

        try samples.forEach { code in
            let result = try ImageCommentsMapper.map(json, from: HTTPResponse(forCode: code))
            XCTAssertEqual(result, [comment.model])
        }
    }
    
    //MARK: -> Helpers
    
    private func aComment() -> (model: ImageComment, json: [String:Any]) {
        makeItem(id: UUID(),
                 message: "a message",
                 createdAt: makeDateTupleFor(iso8601string: "2023-02-28T15:07:02+00:00"),
                 username: "a username"
        )
    }
    
    private func makeDateTupleFor(iso8601string: String) -> (date: Date, iso8601string: String) {
        return (try! Date(iso8601string, strategy: .iso8601), iso8601string)
    }
    
    private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601string: String), username: String)
    -> (model: ImageComment, json: [String:Any]) {
        let item = ImageComment(
            id: id,
            message: message,
            createdAt: createdAt.date,
            username: username
        )
        
        let itemJSON: [String:Any] = [
            "id" : item.id.uuidString,
            "message" : item.message,
            "created_at" : createdAt.iso8601string,
            "author" : [
                "username" : item.username
                ]
        ].compactMapValues({$0})

        return (item, itemJSON)
    }
    
    private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
        return .failure(error)
    }
}
