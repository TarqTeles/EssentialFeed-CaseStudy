//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Tarquinio Teles on 05/01/23.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
