//
//  ChatCell.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

class ChatCell: UITableViewCell {
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue
        return imageView
    }()

    let profileImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .lightGray
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()

    let lastMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = label.font.withSize(16)
        label.textColor = .systemGray
        return label
    }()

    let timestampLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = label.font.withSize(14)
        label.textColor = .systemGray
        return label
    }()

    let arrowImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didTransition(to state: UITableViewCell.StateMask) {
        super.didTransition(to: state)
        switch state.rawValue {
        case 1: self.setSelectionContraints()
        case 0: self.setupConstraints()
        default:
            self.setupConstraints()
        }
    }

    func configure(for chat: Chat) {
        titleLabel.text = chat.title
        lastMessageLabel.text = chat.lastMessage
        timestampLabel.text = ChatService().convertToTimestamp(chat.timestamp) // !TODO Change convertion place
    }

    private func setupConstraints() {
        contentView.addSubview(profileImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(lastMessageLabel)
        contentView.addSubview(timestampLabel)

        let padding: CGFloat = 8.0

        NSLayoutConstraint.activate([
            profileImage.heightAnchor.constraint(equalToConstant: 60),
            profileImage.widthAnchor.constraint(equalToConstant: 60),
            profileImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            profileImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: padding),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),

            lastMessageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            lastMessageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lastMessageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            lastMessageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
            
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            timestampLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 4),
            timestampLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: timestampLabel.leadingAnchor, constant: -padding)
        ])

        timestampLabel.setContentHuggingPriority(.required, for: .horizontal)
        timestampLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func setSelectionContraints() {
        let padding: CGFloat = 8.0
        NSLayoutConstraint.activate([
            lastMessageLabel.trailingAnchor.constraint(equalTo: timestampLabel.trailingAnchor),
            timestampLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])

        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.contentView.layoutIfNeeded()
        }
        
        animator.startAnimation()
    }
}
