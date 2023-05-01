//
//  FeedViewControllerTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Tarquinio Teles on 20/01/23.
//

import Foundation
import XCTest
@testable import EssentialFeed

extension FeedUIIntegrationTests {
    var loadError: String {
        Localized.Shared.loadError
    }
    
    var feedTitle: String {
        Localized.Feed.title
    }
}
