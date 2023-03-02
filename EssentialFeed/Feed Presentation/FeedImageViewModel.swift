//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Tarquinio Teles on 02/03/23.
//

import Foundation

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool
    
    var hasLocation: Bool { location != nil }
}
