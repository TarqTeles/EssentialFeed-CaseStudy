//
//  HTTPClientStub.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 21/03/23.
//

import EssentialFeed

class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    private let stub: (URL) -> HTTPClient.Result
    
    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }
    
    func get(from url: URL, completion: @escaping (Result<(Data, HTTPURLResponse), Error>) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }
    
    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0))})
    }
    
    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub(stub: {url in .success(stub(url))})
    }
}
