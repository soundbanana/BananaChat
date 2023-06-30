//
//  ChatViewControler.swift
//  BananaChat
//
//  Created by Daniil Chemaev on 29.06.2023.
//

import UIKit
import Combine

class ChatViewController: UIViewController {
    private var viewModel: ChatViewModel!
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ChatViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private let messageTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter message"
        return textField
    }()

    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let fetchMessagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Fetch Messages", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()

        viewModel.loadMessages()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8.0

        stackView.addArrangedSubview(messageTextField)
        stackView.addArrangedSubview(sendMessageButton)

        view.addSubview(stackView)
        view.addSubview(fetchMessagesButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -8.0),

            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: fetchMessagesButton.topAnchor, constant: -16.0),

            fetchMessagesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            fetchMessagesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            fetchMessagesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            fetchMessagesButton.heightAnchor.constraint(equalToConstant: 50.0)
        ])

        tableView.dataSource = self

        sendMessageButton.addTarget(self, action: #selector(sendMessageButtonTapped), for: .touchUpInside)
        fetchMessagesButton.addTarget(self, action: #selector(fetchMessagesButtonTapped), for: .touchUpInside)
    }

    private func bindViewModel() {
        viewModel.$messages
            .sink { [weak self] _ in
            self?.tableView.reloadData()
        }
            .store(in: &cancellables)
    }

    @objc private func sendMessageButtonTapped() {
        guard let messageText = messageTextField.text else { return }
        viewModel.sendMessage(messageText)

        // Clear the message text field
        messageTextField.text = ""
    }

    @objc private func fetchMessagesButtonTapped() {
        viewModel.loadMessages()
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)

        let message = viewModel.messages[indexPath.row]

        return cell
    }
}
