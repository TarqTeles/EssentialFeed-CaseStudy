//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 02/03/23.
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool { location != nil }
}
