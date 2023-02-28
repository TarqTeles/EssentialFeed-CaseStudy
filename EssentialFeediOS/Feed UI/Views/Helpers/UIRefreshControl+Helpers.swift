//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 28/02/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
