//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Tarquinio Teles on 01/05/23.
//

import XCTest
@testable import EssentialFeed

final class SharedLocalizationTests: XCTestCase {

    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)
        
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
    
    private class DummyView: ResourceView {        
        func display(_ resourceViewModel: Any) {}
    }
    
}
