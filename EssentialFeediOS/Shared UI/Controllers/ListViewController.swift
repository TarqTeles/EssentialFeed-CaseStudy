//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 25/11/22.
//

import UIKit
import EssentialFeed

public class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {
    public private(set) var errorView = ErrorView()
    
    private lazy var dataSource: UITableViewDiffableDataSource<Int, CellController> = {
        .init(tableView: tableView,
              cellProvider: { (tableView, index, controller) -> UITableViewCell? in
            controller.dataSource.tableView(tableView, cellForRowAt: index) }
        )
    }()
    
    public var onRefresh: (() -> Void)?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource.defaultRowAnimation = .middle
        tableView.dataSource = dataSource
        configureErrorView()
        refresh()
    }
    
    private func configureErrorView() {
        let container = UIView()
        container.backgroundColor = .clear
        container.addSubview(errorView)
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            errorView.topAnchor.constraint(equalTo: container.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        tableView.tableHeaderView = container
        
        errorView.onHide = { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.sizeTableHeaderToFit()
            self?.tableView.endUpdates()
        }
    }

    @IBAction private func refresh() {
        onRefresh?()
    }
    
    public func display(_ cellControllers: [CellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, CellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(cellControllers)
        dataSource.apply(snapshot)
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        errorView.message = viewModel.message
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(forRowAt: indexPath)?.delegate
        dl?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
    }
     
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dl = cellController(forRowAt: indexPath)?.delegate
        dl?.tableView?(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let dsp = cellController(forRowAt: indexPath)?.dataSourcePrefetching
            dsp?.tableView(tableView, prefetchRowsAt: [indexPath])
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach{ indexPath in
            let dsp = cellController(forRowAt: indexPath)?.dataSourcePrefetching
            dsp?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeTableHeaderToFit()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> CellController? {
        dataSource.itemIdentifier(for: indexPath)
    }
    
}

