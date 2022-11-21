//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 10/10/22.
//

import Foundation


public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to the appropriate threads, if needed.
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void)
}
