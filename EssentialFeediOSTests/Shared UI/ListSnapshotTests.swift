//
//  ListSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Tarquinio Teles on 02/05/23.
//

import XCTest
import EssentialFeediOS
@testable import EssentialFeed

final class ListSnapshotTests: XCTestCase {

    func test_emptyFeed() {
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_FEED_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "EMPTY_FEED_dark")
    }
    
    func test_feedWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(ResourceErrorViewModel(message: "This is a\nmulti-line\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "FEED_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone13(style: .dark)), named: "FEED_WITH_ERROR_MESSAGE_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyFeed() -> [CellController] {
        return []
    }
    
}
