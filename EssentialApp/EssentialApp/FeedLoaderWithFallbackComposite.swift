//
//  FeedLoaderWithFallbackComposite.swift
//  EssentialApp
//
//  Created by Tarquinio Teles on 15/03/23.
//

import Foundation
import EssentialFeed

public final class FeedLoaderWithFallbackComposite: FeedLoader {
    private let primaryLoader: FeedLoader
    private let fallbackLoader: FeedLoader
    
    public init(primary: FeedLoader, fallback: FeedLoader) {
        self.primaryLoader = primary
        self.fallbackLoader = fallback
    }
    
    public func load(completion: @escaping (Result<[FeedImage], Error>) -> Void) {
        primaryLoader.load { [weak self] result in
            switch result {
                case .success:
                    completion(result)
                    
                case .failure:
                    self?.fallbackLoader.load(completion: completion)
            }
        }
    }
}
