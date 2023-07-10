//
//  ProfileViewController.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 08.07.2023.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Done", for: .normal)
        return button
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@nickname"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle.fill"))
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .systemGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Surname"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    private func bindViewModel() {
        viewModel.personDataUpdatedPublisher
            .sink { [weak self] in
            self?.updateView()
            }
        .store(in: &cancellables)
    }

    private func updateView() {
        guard let person = viewModel.person else { return }
        firstNameLabel.text = person.firstName
        lastNameLabel.text = person.lastName
        usernameLabel.text = "@\(person.username)"
    }

    private func setupUI() {
        view.backgroundColor = .systemGray6
        title = "Profile"

        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)

        view.addSubview(doneButton)
        view.addSubview(usernameLabel)
        view.addSubview(avatarImageView)
        view.addSubview(editButton)
        view.addSubview(firstNameLabel)
        view.addSubview(lastNameLabel)

        let padding = 16.0

        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),

            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: doneButton.bottomAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 150),
            avatarImageView.heightAnchor.constraint(equalToConstant: 150),

            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor),

            firstNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            firstNameLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: padding),

            lastNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: padding),

            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            usernameLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: padding)
        ])
    }

    @objc private func doneButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
