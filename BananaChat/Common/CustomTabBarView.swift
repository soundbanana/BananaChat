//
//  CustomTabBarView.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 11.07.2023.
//

import UIKit

class CustomTabBarView: UIView {
    private let topLineLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        return layer
    }()

    private let readAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Read All", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        layer.addSublayer(topLineLayer)
        backgroundColor = .systemGray6
        
        addSubview(readAllButton)
        addSubview(deleteButton)

        // Position the buttons within the custom tab bar
        readAllButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            readAllButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            readAllButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),

            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        topLineLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1 / UIScreen.main.scale)
    }

    func setDeleteButtonEnabled(_ isEnabled: Bool) {
        deleteButton.isEnabled = isEnabled
    }
}
