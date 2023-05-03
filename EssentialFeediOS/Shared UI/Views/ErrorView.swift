//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Tarquinio Teles on 28/02/23.
//

import UIKit

public final class ErrorView: UIButton {
    public var message: String? {
        get { return isVisible ? title(for: .normal) : nil }
    }
    
    public var onHide: (() -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private var titleAttributes: AttributeContainer {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center

        var attributes = AttributeContainer()
        attributes.paragraphStyle = paragraphStyle
        attributes.font = UIFont.preferredFont(forTextStyle: .body)
        return attributes
    }

    private func configure() {
        var configuration = Configuration.plain()
        configuration.titlePadding = 0
        configuration.baseForegroundColor = .white
        configuration.background.backgroundColor = .errorBackgroundColor
        configuration.background.cornerRadius = 0
        self.configuration = configuration

        addTarget(self, action: #selector(hideMessageAnimated), for: .touchUpInside)

        hideMessage()
    }

    private var isVisible: Bool {
        return alpha > 0
    }

    func show(message: String) {
        setTitle(message, for: .normal)

        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }

    @objc func hideMessageAnimated() {
        UIView.animate(
            withDuration: 0.25,
            animations: { self.alpha = 0 },
            completion: { completed in
                if completed {
                    self.hideMessage()
                }
            })
    }
    
    private func hideMessage() {
        setTitle(nil, for: .normal)
        self.alpha = 0
        largeContentImageInsets = .init(top: -2.5, left: 8, bottom: -2.5, right: 8)
        onHide?()
    }
}

extension UIColor {
    static var errorBackgroundColor: UIColor {
        UIColor(red: 0.99951404330000004, green: 0.41759261489999999, blue: 0.4154433012, alpha: 1)
    }
}
