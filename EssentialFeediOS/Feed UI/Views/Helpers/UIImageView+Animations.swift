//
//  UIImageView+Animations.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 19/01/23.
//

import UIKit

extension UIImageView {
    func setAnimatedImage(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
