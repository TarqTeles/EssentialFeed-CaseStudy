//
//  FeedViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Tarquinio Teles on 05/01/23.
//

import UIKit
import EssentialFeediOS

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()
        
        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }
    
    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var errorMessage: String? {
        errorView.message
    }
    
    func simulateTapOnErrorMessage() {
        errorView.simulateTap()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    static func executeRunLoopToCleanUpReferences() {
        RunLoop.current.run(until: Date())
    }
}

extension ListViewController {
    // MARK: - FeedImage
    
    @discardableResult
    func simulateFeedImageViewVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index) as? FeedImageCell
    }
    
    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    func simulateTapOnFeedImage(at row: Int) {
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func simulateLoadMoreFeedAction() {
        guard let view = cell(row: 0, section: feedLoadMoreSection) else { return }
        
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, willDisplay: view, forRowAt: index)
    }
    
    func simulateTapOnLoadMoreFeedErrorMessage() {
        guard loadMoreCell() != nil else { return }
        
        let delegate = tableView.delegate
        let index = IndexPath(row: 0, section: feedLoadMoreSection)
        delegate?.tableView?(tableView, didSelectRowAt: index)
    }
    
    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImage
    }
    
    func numberOfRenderedFeedImageViews() -> Int {
        tableView.numberOfSections == 0 ? 0 :
        tableView.numberOfRows(inSection: feedImageSection)
    }
    
    var canLoadMoreFeed: Bool {
        return loadMoreCell() != nil
    }
    
    func feedImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedFeedImageViews() > row else {
            return nil
        }

        return cell(row: row, section: feedImageSection)
    }
    
    var isShowingLoadMoreIndicator: Bool {
        return loadMoreCell()?.isLoading == true
    }
    
    var loadMoreFeedErrorMessage: String? {
        return loadMoreCell()?.message
    }
    
    func loadMoreCell() -> LoadMoreCell? {
        return cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
    }
    
    private func cell(row: Int, section: Int) -> UITableViewCell? {
        guard tableView.numberOfSections > section else { return nil }
        
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var feedImageSection: Int { 0 }
    private var feedLoadMoreSection: Int { 1 }
}

extension ListViewController {
    // MARK: - ImageComment
    
    func numberOfRenderedComments() -> Int {
        tableView.numberOfSections == 0 ? 0 :
        tableView.numberOfRows(inSection: commentsSection)
    }
    
    private func commentCell(at row: Int) -> ImageCommentCell? {
        guard numberOfRenderedComments() > row else {
            return nil
        }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: commentsSection)
        return ds?.tableView(tableView, cellForRowAt: index) as? ImageCommentCell
    }

    func commentMessage(at row: Int) -> String? {
        let cell = commentCell(at: row)
        return cell?.messageLabel.text
    }
    
    func commentUsername(at row: Int) -> String? {
        let cell = commentCell(at: row)
        return cell?.usernameLabel.text
    }
    
    func commentDate(at row: Int) -> String? {
        let cell = commentCell(at: row)
        return cell?.dateLabel.text
    }
    
    var commentsSection: Int { 0 }
}

