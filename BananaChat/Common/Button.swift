//
//  Button.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 10.07.2023.
//

import UIKit

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    init(title: String) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func commonInit() {
        configureAppearance()
        setupConstraints()
    }

    private func configureAppearance() {
        self.layer.cornerRadius = 15
        self.setTitleColor(.systemBackground, for: .normal)
        self.backgroundColor = .label
    }

    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }

    // MARK: - Touch Handling

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateButtonScale(scale: 0.9)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animateButtonScale(scale: 1.0)
    }

    private func animateButtonScale(scale: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
