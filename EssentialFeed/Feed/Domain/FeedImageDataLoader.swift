//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 05/01/23.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
