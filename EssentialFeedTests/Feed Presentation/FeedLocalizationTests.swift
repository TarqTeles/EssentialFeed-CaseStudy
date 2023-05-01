//
//  FeedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 02/03/23.
//

import XCTest
@testable import EssentialFeed

class FeedLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
}
