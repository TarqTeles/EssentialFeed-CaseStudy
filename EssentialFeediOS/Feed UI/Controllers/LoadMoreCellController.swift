//
//  LoadMoreCellController.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 04/05/23.
//

import UIKit
import EssentialFeed

public final class LoadMoreCellController: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let cell = LoadMoreCell()
    private let callback: () -> Void
    private var offsetObserver: NSKeyValueObservation?
    private var initialDraggingY: CGFloat?
    
    public init(callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        reloadIfNeeded()
        
        offsetObserver = tableView.observe(\.contentOffset, options: .new, changeHandler: { [weak self] (tableView, value) in
            guard tableView.isDragging else { return }

            self?.setInitialDraggingY(to: value.newValue?.y)
            
            if self?.enoughDragging(value.newValue?.y) == true {
                self?.reloadIfNeeded()
            }
        })
    }
        
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        offsetObserver = nil
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reloadIfNeeded()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard cell.message == nil else { return }

        if scrollView.contentOffset.y + cell.frame.height >= scrollView.contentSize.height - (scrollView.frame.height * 1.5) {
            reloadIfNeeded()
        }
    }
    
    private func reloadIfNeeded() {
        guard !self.cell.isLoading else { return }

        callback()
    }
    
    private func setInitialDraggingY(to currentY: CGFloat?) {
        guard initialDraggingY == nil else { return }
        
        self.initialDraggingY = currentY
    }
    
    private func enoughDragging(_ currentY: CGFloat?) -> Bool {
        guard let initY = initialDraggingY, let currY = currentY else { return false }
        
        let draggedDistance = (currY - initY)
        return draggedDistance > reasonableDistance
    }
    
    private var reasonableDistance = 135.0
    
}

extension LoadMoreCellController: ResourceLoadingView, ResourceErrorView {
    public func display(_ viewModel: EssentialFeed.ResourceErrorViewModel) {
        cell.message = viewModel.message
    }
    
    public func display(_ viewModel: EssentialFeed.ResourceLoadingViewModel) {
        cell.isLoading = viewModel.isLoading
    }
}
