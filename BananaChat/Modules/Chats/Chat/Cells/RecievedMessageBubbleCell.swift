//
//  RecievedMessageBubbleCell.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

class RecievedMessageBubbleCell: UITableViewCell {
    private let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = .systemGreen
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private let messageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let bubbleInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        bubbleView.addSubview(messageLabel)
        messageStackView.addSubview(bubbleView)
        contentView.addSubview(messageStackView)

        NSLayoutConstraint.activate([
            messageStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            messageStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
            messageStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            messageStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),

            bubbleView.topAnchor.constraint(equalTo: messageStackView.topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: messageStackView.bottomAnchor, constant: -1),
            bubbleView.leftAnchor.constraint(equalTo: messageStackView.leftAnchor, constant: 16),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: bubbleInsets.top),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: bubbleInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -bubbleInsets.right),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -bubbleInsets.bottom)
        ])

        bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width).isActive = true

        bubbleView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }

    func configure(with message: String) {
        messageLabel.text = message
    }
}
