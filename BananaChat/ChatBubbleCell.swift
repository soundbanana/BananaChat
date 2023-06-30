//
//  ChatBubbleCell.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 30.06.2023.
//

import UIKit

import UIKit

class ChatBubbleCell: UITableViewCell {
    static let reuseIdentifier = "ChatBubbleCell"

    private let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()

    private let bubbleInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),

            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: bubbleInsets.top),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: bubbleInsets.left),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -bubbleInsets.right),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -bubbleInsets.bottom),
            ])

        bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: contentView.frame.width).isActive = true

        bubbleView.transform = bubbleView.transform.rotated(by: .pi)
    }

    func configure(with message: String, isSentByUser: Bool) {
        messageLabel.text = message

        bubbleView.backgroundColor = isSentByUser ? .blue : .green
    }
}
