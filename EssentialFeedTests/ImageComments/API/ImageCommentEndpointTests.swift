//
//  ImageCommentEndpoint.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 09/05/23.
//

import XCTest
import EssentialFeed

final class ImageCommentEndpointTests: XCTestCase {

    func test_imageComment_endpointURL() {
        let baseURL = URL(string: "https://base-url.com")!
        let imageId = UUID()
        
        let received: URL = ImageCommentEndpoint.get(imageId).url(baseURL: baseURL)
        
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "/v1/image/\(imageId.uuidString)/comments", "path")
    }

}
