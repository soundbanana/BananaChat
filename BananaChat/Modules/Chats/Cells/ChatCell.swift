//
//  ChatCell.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 03.07.2023.
//

import UIKit

class ChatCell: UITableViewCell {
    let profileImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        return imageView
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "Test Test"
        label.textColor = .black
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = label.font.withSize(16)
        label.textColor = .systemGray
        label.text = "Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test "
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = label.font.withSize(14)
        label.textColor = .systemGray6
        return label
    }()

    let arrowImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.backward"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        contentView.addSubview(profileImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)

        let padding = 8.0

        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: padding),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding), // TODO right anchor

            profileImage.heightAnchor.constraint(equalToConstant: 55),
            profileImage.widthAnchor.constraint(equalToConstant: 55),
            profileImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            profileImage.topAnchor.constraint(equalTo: nameLabel.centerYAnchor),

            messageLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding), // TODO right anchor
            ])
    }
}
