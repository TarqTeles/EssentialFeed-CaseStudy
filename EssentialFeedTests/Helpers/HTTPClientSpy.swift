//
//  HTTPClientSpy.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 07/03/23.
//

import EssentialFeed

class HTTPClientSpy: HTTPClient {
    private struct Task: HTTPClientTask {
        let callback: () -> Void
        func cancel() { callback() }
    }
    
    private(set) public var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
    private(set) public var cancelledURLs = [URL]()
    
    var requestedURLs: [URL] {
        messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        messages.append((url, completion))
        return Task { [weak self] in
            self?.cancelledURLs.append(url)
        }
    }
            
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
        let response = HTTPURLResponse(url: messages[index].url,
                                       statusCode: code,
                                       httpVersion: nil,
                                       headerFields: nil
        )!
        messages[index].completion(.success((data, response)))
    }
}

