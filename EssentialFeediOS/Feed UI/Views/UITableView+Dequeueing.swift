//
//  UITableView+Dequeueing.swift
//  EssentialFeediOSTests
//
//  Created by Tarquinio Teles on 19/01/23.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
