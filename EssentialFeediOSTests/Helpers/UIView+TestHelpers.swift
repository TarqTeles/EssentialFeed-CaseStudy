//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Tarquinio Teles on 23/03/23.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
