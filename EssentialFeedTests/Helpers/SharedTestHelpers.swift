//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 27/10/22.
//

import Foundation


func anyURL() -> URL { URL(string: "http://any-url.com")! }

func anyNSError() -> NSError{ NSError(domain: "any error", code: 1) }

func anyData() -> Data { Data("any data".utf8) }

func HTTPResponse(forCode statusCode: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeItemsJSON(_ items: [[String:Any]]) -> Data {
    let json = [ "items" : items ]
    return try! JSONSerialization.data(withJSONObject: json)
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
